<?php

namespace Barrett\Finder;

use Nette\Utils\Finder;
use Symplify\EasyCodingStandard\Contract\Finder\CustomSourceProviderInterface;

final class PhpFilesProvider implements CustomSourceProviderInterface
{
    /**
     * @param string[] $source
     * @return mixed[]
     */
    public function find(array $source)
    {
        # $source is "source" argument passed in CLI
        # inc CLI: "vendor/bin/ecs check /src" => here: ['/src']
        return Finder::find('*.php', '*.module')->in($source);
    }

}
