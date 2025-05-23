<?php
require_once __DIR__ . '/vendor/autoload.php';

use Dotenv\Dotenv;

$dotenv = Dotenv::createImmutable(__DIR__);
$dotenv->load();

$appVar = $_ENV['APP_VAR'] ?? 'variable no definida';

echo "Hola desde Jenkins con PHP 8.2 en Docker! 🚀\n";
echo "Valor de APP_VAR: {$appVar}\n";