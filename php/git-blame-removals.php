<?php

/**
 * @file
 * Show git blame on lines that have been changed or removed.
 *
 * Print out lines that have been changed or removed along with the git blame
 * info on who last made changes to that line.
 */

// Get the sha value (or branch) to compare against.
if (empty($argv[1])) {
  return;
}
$sha = $argv[1];

// Initial values for some variables.
$files = [];
$return = 0;

// Output colors.
$red = "\e[0;31m";
$yellow = "\e[0;33m";
$no_color = "\e[0m";

// Find files that have been changed between the provided sha and this commit.
exec("git diff-index --name-only $(git merge-base HEAD $sha)", $files);

// Ignore filenames that contain these strings.
$ignore_filename_strings = [
  '_default.inc',
  'context.inc',
  'ds.inc',
  'features',
  'field_group.inc',
  'rules_defaults',
  'strongarm.inc',
];

// Ignore file paths that contain these strings.
$ignore_file_path_strings = [
  'contrib',
  'core',
  'vendor',
];

// Loop through each file that has been modified.
foreach ($files as $file) {
  // Skip files that don't exist.
  if (!file_exists($file)) {
    continue;
  }

  // Get the filename and extension.
  $filename = pathinfo($file, PATHINFO_BASENAME);
  $ext = pathinfo($file, PATHINFO_EXTENSION);

  // Skip over the file if it matches an ignored filename or an ignored file
  // path.
  $ignore_filenames = array_filter($ignore_filename_strings, function ($item) use ($filename) {
    return strpos($filename, $item) !== FALSE;
  });
  $ignore_file_paths = array_filter($ignore_file_path_strings, function ($item) use ($file) {
    return strpos($file, $item) !== FALSE;
  });

  $diffs = [];
  $removal_diffs = [];

  // Get lines that have been removed (starting with '- ').
  exec("git diff $sha $file | grep ^'- ' | sed -e 's/^- *//g'", $removal_diffs);
  foreach ($removal_diffs as $removal_diff) {
    // Skip lines with not enough characters.
    if (strlen($removal_diff) < 4) {
      continue;
    }

    // Run a git blame and find the line that matches the removed line.
    $quote = '^[^(]*? (\([^)]*\))\s*' . str_replace('\$', '.', preg_quote($removal_diff)) . '$';
    exec("git blame --date=relative $sha -- $file | grep -E \"$quote\"", $d);
    $diffs += $d;
  }

}

// If there were any lines removed, print them out.
if (!empty($diffs)) {
  echo "\n{$yellow}Lines changed:{$no_color}\n" . implode("\n", $diffs), "\n";
}
