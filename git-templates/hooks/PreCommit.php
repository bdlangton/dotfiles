<?php

/**
 * @file
 * Pre-commit console application to run checks on committed code.
 */

use Bdlangton\Php\Git\ApplicationBase;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Process\Process;

/**
 * Pre-commit class to handle all pre-commit hooks.
 */
class PreCommit extends ApplicationBase {

  /**
   * File extensions to check.
   *
   * If a modified file doesn't contain one of these extensions, then it will
   * be skipped.
   *
   * @var array
   */
  protected $fileExtensions = [
    'php',
    'module',
    'inc',
    'install',
    'test',
    'profile',
    'theme',
    'txt',
    'class',
    'json',
  ];

  /**
   * PHP File extensions.
   *
   * Only files ending with these extensions will be checked by PHP checks.
   *
   * @var array
   */
  protected $phpFileExtensions = [
    'php',
    'module',
    'inc',
    'install',
    'test',
    'profile',
    'theme',
    'class',
  ];

  /**
   * Ignore filenames that contain these strings.
   *
   * @var array
   */
  protected $ignoreFilenameStrings = [
    '_default.inc',
    'context.inc',
    'ds.inc',
    'features',
    'field_group.inc',
    'rules_defaults',
    'strongarm.inc',
  ];

  /**
   * Ignore file paths that contain these strings.
   *
   * @var array
   */
  protected $ignoreFilePathStrings = [
    'contrib',
    'core',
    'vendor',
  ];

  /**
   * Constructor.
   */
  public function __construct() {
    $this->projectRoot = realpath(__DIR__ . '/../../');
    $gitRoot = NULL;
    exec("git rev-parse --show-toplevel", $gitRoot);
    $this->gitRoot = $gitRoot[0] ?? '';
    parent::__construct('Pre Commit', '1.0.0');
  }

  /**
   * {@inheritdoc}
   */
  public function doRun(InputInterface $input, OutputInterface $output) {
    // Exceptions found.
    $exceptions = '';

    $this->input = $input;
    $this->output = $output;

    $files = $this->getChangedFiles();
    $project_type = $this->getProjectType();

    // PHP specific tests.
    if ($project_type == 'php') {
      // These checks require valid changed files.
      if (!empty($files)) {
        // PHPCS.
        $output->writeln("<fg=white;options=bold;bg=cyan> -- Checking PHPCS -- </fg=white;options=bold;bg=cyan>\n");
        if (!$this->checkPhpcs($files)) {
          $exceptions .= "There were PHPCS errors that need fixed.\n";
        }

        // PHP Lint.
        $output->writeln("<fg=white;options=bold;bg=cyan> -- Checking PHP Lint -- </fg=white;options=bold;bg=cyan>\n");
        if (!$this->checkPhpLint($files)) {
          $exceptions .= "There were PHP Linting errors that need fixed.\n";
        }

        // PHPMD.
        $output->writeln("<fg=white;options=bold;bg=cyan> -- Checking PHPMD -- </fg=white;options=bold;bg=cyan>\n");
        if (!$this->checkPhpmd($files)) {
          $exceptions .= "There were PHPMD errors that need fixed.\n";
        }

        // PHP Debugging.
        $output->writeln("<fg=white;options=bold;bg=cyan> -- Checking PHP Debugging -- </fg=white;options=bold;bg=cyan>\n");
        if (!$this->checkPhpDebugging($files)) {
          $exceptions .= "There were PHP Debugging errors that need fixed.\n";
        }

        // Composer.
        $output->writeln("<fg=white;options=bold;bg=cyan> -- Checking Composer -- </fg=white;options=bold;bg=cyan>\n");
        if (!$this->checkComposer($files)) {
          $exceptions .= "Composer validation failed.\n";
        }
      }

      // PHPCPD.
      $output->writeln("<fg=white;options=bold;bg=cyan> -- Checking PHPCPD -- </fg=white;options=bold;bg=cyan>\n");
      if (!$this->checkPhpcpd()) {
        $exceptions .= "There were PHPCPD errors that need fixed.\n";
      }
    }

    // If any exceptions were found, throw an exception.
    if (!empty($exceptions)) {
      throw new \Exception($exceptions);
    }
  }

  /**
   * Check files against phpcs.
   *
   * Recommended phpcs settings:
   *   phpcs --config-set installed_paths
   *     ~/.composer/vendor/drupal/coder/coder_sniffer
   *   phpcs --config-set default_standard Drupal
   *   phpcs --config-set colors 1
   *   phpcs --config-set ignore_warnings_on_exit 1
   *
   * @param array $files
   *   Array of files to check.
   * @param string $standard
   *   The coding standard to use.
   *
   * @return bool
   *   Return TRUE if the check passed, FALSE otherwise.
   */
  protected function checkPhpcs(array $files, string $standard = 'Drupal') {
    $processArgs = [
      'phpcs',
      '--standard=' . $standard,
      '--extensions=' . implode(',', $this->phpFileExtensions),
    ];

    foreach ($files as $file) {
      $processArgs[3] = $file;

      $process = new Process($processArgs);
      $process->setWorkingDirectory($this->projectRoot);
      $process->run();

      if (!$process->isSuccessful()) {
        $this->output->writeln($file);
        $this->output->writeln(sprintf('<error>%s</error>', trim($process->getOutput())));
        $this->output->writeln('');
        return FALSE;
      }
      elseif (!empty($process->getOutput())) {
        // Print output that exists but don't fail the commit.
        $this->output->writeln($file);
        $this->output->writeln(sprintf('<fg=yellow>%s</fg=yellow>', trim($process->getOutput())));
        $this->output->writeln('');
      }
    }
    return TRUE;
  }

  /**
   * Check files against php lint.
   *
   * @param array $files
   *   Array of files to check.
   *
   * @return bool
   *   Return TRUE if the check passed, FALSE otherwise.
   */
  protected function checkPhpLint(array $files) {
    $processArgs = [
      'php',
      '-l',
    ];

    foreach ($files as $file) {
      // Skip non-PHP files.
      if (!$this->verifyPhpFile($file)) {
        continue;
      }

      $processArgs[2] = $file;

      $process = new Process($processArgs);
      $process->setWorkingDirectory($this->projectRoot);
      $process->run();

      if (!$process->isSuccessful()) {
        $this->output->writeln($file);
        $this->output->writeln(sprintf('<error>%s</error>', trim($process->getOutput())));
        $this->output->writeln('');
        return FALSE;
      }
    }
    return TRUE;
  }

  /**
   * Check files against phpmd.
   *
   * @param array $files
   *   Array of files to check.
   *
   * @return bool
   *   Return TRUE if the check passed, FALSE otherwise. For now, this will
   *   print out errors if they exist, but it will always pass.
   */
  protected function checkPhpmd(array $files) {
    $processArgs = [
      'phpmd',
      '',
      'text',
      '.git/hooks/phpmd-ruleset.xml',
      '--suffixes php,inc,module,install,test,profile',
    ];

    foreach ($files as $file) {
      // Skip non-PHP files.
      if (!$this->verifyPhpFile($file)) {
        continue;
      }

      $processArgs[1] = $file;

      $process = new Process($processArgs);
      $process->setWorkingDirectory($this->projectRoot);
      $process->run();

      if (!$process->isSuccessful()) {
        $this->output->writeln($file);
        $this->output->writeln(sprintf('<fg=yellow>%s</fg=yellow>', trim($process->getOutput())));
        $this->output->writeln('');
      }
    }
    return TRUE;
  }

  /**
   * Check files for any debugging code left in.
   *
   * @param array $files
   *   Array of files to check.
   *
   * @return bool
   *   Return TRUE if the check passed, FALSE otherwise.
   */
  protected function checkPhpDebugging(array $files) {
    $processArgs = [
      'git',
      'diff',
      '--cached',
      '--unified=0',
    ];

    // Debugging code segments to make sure they weren't committed.
    $debugging_searches = [
      'dpm(',
      'dvm(',
      'dsm(',
      'dpr(',
      'kpr(',
      'ksm(',
      'kint(',
      'dvr(',
      'print_r(',
      'var_dump(',
      'var_export(',
      'console\.log',
    ];

    foreach ($files as $file) {
      // Check for debugging code that was committed.
      foreach ($debugging_searches as $search) {
        $processArgs[4] = $file;
        $gitdiff = new Process($processArgs);
        $gitdiff->setWorkingDirectory($this->projectRoot);
        $gitdiff->run();

        // TODO: This is not actually getting debugging code.
        $process = new Process(['grep', '\+.*' . $search]);
        $process->setInput($gitdiff->getOutput());
        $process->run();

        if (!$process->isSuccessful() && $process->getOutput()) {
          $this->output->writeln($file);
          $this->output->writeln(sprintf('<error>Found %s in the code</error>', $search));
          $this->output->writeln('');
          return FALSE;
        }
      }

    }
    return TRUE;
  }

  /**
   * Check if composer is valid if composer.json was updated.
   *
   * @param array $files
   *   Array of files to check.
   *
   * @return bool
   *   Return TRUE if the check passed, FALSE otherwise.
   */
  private function checkComposer(array $files) {
    foreach ($files as $file) {
      if (strpos($file, 'composer.json') !== FALSE) {
        $process = new Process([
          'composer',
          'validate',
          '--no-check-all',
          '--ansi',
        ]);
        $directory = explode('composer.json', $file);
        $process->setWorkingDirectory($directory[0]);
        $process->run();

        if (!$process->isSuccessful()) {
          $this->output->writeln($process->getErrorOutput());
          $this->output->writeln('');
          return FALSE;
        }
      }
    }

    return TRUE;
  }

  /**
   * Check files against phpcpd.
   *
   * @return bool
   *   Return TRUE if the check passed, FALSE otherwise.
   */
  protected function checkPhpcpd() {
    $process = new Process([
      'phpcpd',
      '--exclude=vendor',
      '--exclude=core',
      '--exclude=contrib',
      '--exclude=sites/default',
      '.',
    ]);
    $process->setWorkingDirectory($this->projectRoot);
    $process->run();

    if (!$process->isSuccessful()) {
      $this->output->writeln(sprintf('<error>%s</error>', trim($process->getOutput())));
      $this->output->writeln('');
      return FALSE;
    }
    return TRUE;
  }

}
