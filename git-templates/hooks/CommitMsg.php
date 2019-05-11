<?php

/**
 * @file
 * Commit-msg console application to run checks on commit message.
 */

require getenv('HOME') . '/.php/ApplicationBase.php';

use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

/**
 * Commit-msg class to handle all commit-msg hooks.
 */
class CommitMsg extends ApplicationBase {

  /**
   * Commit message.
   *
   * @var string
   */
  protected $message;

  /**
   * Constructor.
   *
   * @param string $file
   *   The file that contains the commit message.
   */
  public function __construct(string $file) {
    $this->message = file_get_contents($file);
    parent::__construct('Commit Msg', '1.0.0');
  }

  /**
   * {@inheritdoc}
   */
  public function doRun(InputInterface $input, OutputInterface $output) {
    // Exceptions found.
    $exceptions = '';

    $this->input = $input;
    $this->output = $output;

    $output->writeln("<fg=white;options=bold;bg=cyan> -- Checking Commit-Msg -- </fg=white;options=bold;bg=cyan>\n");

    $line_num = 1;
    foreach (preg_split('/\v/', $this->message, -1) as $line) {
      // Once we reach commented out lines auto generated by git then we are done.
      if (substr($line, 0, 1) == '#') {
        break;
      }

      // The first line.
      if ($line_num == 1) {
        // The subject should be 50 characters or less.
        // This is not required, just recommended.
        if (strlen($line) > 50) {
          $output->writeln('<info>Warning: The commit subject should be 50 characters or less. Yours is ' . strlen($line) . ' characters.</info>');
        }

        // The subject must begin with a capital letter.
        if (!ctype_upper(substr($line, 0, 1))) {
          $exceptions .= "Error: The commit subject must start with a capital letter.\n";
        }

        // The subject must not end in a period.
        if (substr($line, -1, 1) == '.') {
          $exceptions .= "Error: The commit subject must not end with a period.\n";
        }
      }

      // The second line (if it exists) must be blank.
      if ($line_num == 2 && !empty($line)) {
        $exceptions .= "Error: The second line of the commit message must be blank.\n";
      }

      // The third line: start of the body.
      if ($line_num == 3) {
        // The body must begin with a capital letter.
        if (!ctype_upper(substr($line, 0, 1))) {
          $exceptions .= "Error: The commit body must start with a capital letter.\n";
        }
      }

      // Every line must be 72 characters or less.
      if (strlen($line) > 72) {
        $exceptions .= "Error: Every line of the commit message must be 72 characters or less. Line $line_num is " . strlen($line) . " characters.\n";
      }

      $line_num++;
    }

    // If any exceptions were found, throw an exception.
    if (!empty($exceptions)) {
      throw new \Exception($exceptions);
    }
  }

}
