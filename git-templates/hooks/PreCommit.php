<?php

/**
 * @file
 * Pre-commit console application to run checks on committed code.
 */

require getenv('HOME') . '/.php/ApplicationBase.php';

use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Process\Process;

/**
 * Pre-commit class to handle all pre-commit hooks.
 */
class PreCommit extends ApplicationBase {

  /**
   * The Symfony output interface.
   *
   * @var Symfony\Component\Console\Output\OutputInterface
   */
  protected $output;

  /**
   * The Symfony input interface.
   *
   * @var Symfony\Component\Console\Input\InputInterface
   */
  protected $input;

  /**
   * The directory of the project root (the git hooks directory).
   *
   * @var string
   */
  protected $projectRoot;

  /**
   * The root directory of the git repo.
   *
   * @var string
   */
  protected $gitRoot;

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

    $output->writeln('<fg=white;options=bold;bg=cyan> -- Code Quality Pre-Commit Check -- </fg=white;options=bold;bg=cyan>');
    $output->writeln('<info>Fetching files</info>');
    $files = $this->getChangedFiles();

    // These checks require valid changed files.
    if (!empty($files)) {
      // PHPCS.
      $output->writeln('<info>Checking PHPCS</info>');
      if (!$this->checkPhpcs($files)) {
        $exceptions .= "There were PHPCS errors that need fixed.\n";
      }

      // PHP Lint.
      $output->writeln('<info>Checking PHP Lint</info>');
      if (!$this->checkPhpLint($files)) {
        $exceptions .= "There were PHP Linting errors that need fixed.\n";
      }

      // PHPMD.
      $output->writeln('<info>Checking PHPMD</info>');
      if (!$this->checkPhpmd($files)) {
        $exceptions .= "There were PHPMD errors that need fixed.\n";
      }

      // PHP Debugging.
      $output->writeln('<info>Checking PHP Debugging</info>');
      if (!$this->checkPhpDebugging($files)) {
        $exceptions .= "There were PHP Debugging errors that need fixed.\n";
      }
    }

    // PHPCPD.
    $output->writeln('<info>Checking PHPCPD</info>');
    if (!$this->checkPhpcpd()) {
      $exceptions .= "There were PHPCPD errors that need fixed.\n";
    }

    // Composer.
    $output->writeln('<info>Checking Composer</info>');
    if (!$this->checkComposer($files)) {
      $exceptions .= 'Composer error: composer.lock must be commited if composer.json is modified.';
    }

    // If any exceptions were found, throw an exception.
    if (!empty($exceptions)) {
      throw new \Exception($exceptions);
    }
    else {
      $output->writeln('<fg=white;options=bold;bg=green> -- Code Quality: Passed! -- </fg=white;options=bold;bg=green>');
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
    $commandLineArgs = [
      'phpcs',
      '--standard=' . $standard,
      '--extensions=' . implode(',', $this->fileExtensions),
    ];

    foreach ($files as $file) {
      $commandLineArgs[3] = $file;

      $process = new Process($commandLineArgs);
      $process->setWorkingDirectory($this->projectRoot);
      $process->run();

      if (!$process->isSuccessful()) {
        $this->output->writeln($file);
        $this->output->writeln(sprintf('<error>%s</error>', trim($process->getErrorOutput())));
        $this->output->writeln(sprintf('<info>%s</info>', trim($process->getOutput())));
        return FALSE;
      }
      elseif (!empty($process->getOutput())) {
        // Print output that exists but don't fail the commit.
        $this->output->writeln($file);
        $this->output->writeln(sprintf('<info>%s</info>', trim($process->getOutput())));
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
    $commandLineArgs = [
      'php',
      '-l',
    ];

    foreach ($files as $file) {
      $commandLineArgs[2] = $file;

      $process = new Process($commandLineArgs);
      $process->setWorkingDirectory($this->projectRoot);
      $process->run();

      if (!$process->isSuccessful()) {
        $this->output->writeln($file);
        $this->output->writeln(sprintf('<error>%s</error>', trim($process->getErrorOutput())));
        $this->output->writeln(sprintf('<info>%s</info>', trim($process->getOutput())));
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
    $commandLineArgs = [
      'phpmd',
      '',
      'text',
      '.git/hooks/phpmd-ruleset.xml',
      '--suffixes php,inc,module.install,test,profile',
    ];

    foreach ($files as $file) {
      $commandLineArgs[1] = $file;

      $process = new Process($commandLineArgs);
      $process->setWorkingDirectory($this->projectRoot);
      $process->run();

      if (!$process->isSuccessful()) {
        $this->output->writeln($file);
        $this->output->writeln(sprintf('<error>%s</error>', trim($process->getErrorOutput())));
        $this->output->writeln(sprintf('<info>%s</info>', trim($process->getOutput())));
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
    $commandLineArgs = [
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
        $commandLineArgs[4] = $file;
        $gitdiff = new Process($commandLineArgs);
        $gitdiff->setWorkingDirectory($this->projectRoot);
        $gitdiff->run();
        $process = new Process(['grep', '\+.*' . $search]);
        $process->setInput($gitdiff->getOutput());
        $process->run();

        if (!$process->isSuccessful() && !empty($process->getOutput())) {
          $this->output->writeln($file);
          $this->output->writeln(sprintf('<error>%s</error>', trim($process->getErrorOutput())));
          $this->output->writeln(sprintf('<info>%s</info>', trim($process->getOutput())));
          return FALSE;
        }
      }

    }
    return TRUE;
  }

  /**
   * Check if composer.json was changed, that composer.lock is also changed.
   *
   * @param array $files
   *   Array of files to check.
   *
   * @return bool
   *   Return TRUE if the check passed, FALSE otherwise.
   */
  private function checkComposer(array $files) {
    $composerJsonDetected = FALSE;
    $composerLockDetected = FALSE;

    foreach ($files as $file) {
      if ($file === 'composer.json') {
        $composerJsonDetected = TRUE;
      }

      if ($file === 'composer.lock') {
        $composerLockDetected = TRUE;
      }
    }

    if ($composerJsonDetected && !$composerLockDetected) {
      return FALSE;
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
    $commandLineArgs = [
      'phpcpd',
      '--exclude=vendor',
      '--exclude=core',
      '--exclude=contrib',
      '--exclude=sites/default',
      '.',
    ];

    $process = new Process($commandLineArgs);
    $process->setWorkingDirectory($this->projectRoot);
    $process->run();

    if (!$process->isSuccessful()) {
      $this->output->writeln(sprintf('<error>%s</error>', trim($process->getErrorOutput())));
      $this->output->writeln(sprintf('<info>%s</info>', trim($process->getOutput())));
      return FALSE;
    }
    return TRUE;
  }

}
