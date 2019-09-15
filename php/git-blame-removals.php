#!/usr/bin/php
<?php

/**
 * @file
 * Run GitBlameRemovals.
 */

require getenv('HOME') . '/.composer/vendor/autoload.php';

use Bdlangton\Php\Git\GitBlameRemovals;

$console = new GitBlameRemovals($argv[1]);
$console->run();
