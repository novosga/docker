#!/usr/local/bin/php

<?php

function format($str, array $args = array())
{
  foreach ($args as $k => $v) {
    $str = str_replace('{'.$k.'}', $v, $str);
  }
  return $str;
}

$conn = new PDO (getenv("DATABASE_SGDB").':host='.getenv("DATABASE_HOST").';dbname='.getenv("DATABASE_NAME"), getenv("DATABASE_USER"), getenv("DATABASE_PASSWORD"));

if($query = $conn->query('select valor from config where chave="version"')) {
  echo "Updating DB schema: ";	
  $versaoatual = $query->fetchObject()->valor;
  $arquivosmigracao="/var/www/html/src/Novosga/Install/sql/migration";
  $arquivos=glob("$arquivosmigracao/*.sql");
  foreach ($arquivos as $arquivo) {
    $versaomig = str_replace('.sql', '', basename($arquivo));
    if ( $versaomig <= getenv("VERSION") && $versaomig > $versaoatual )
      $conn->exec($arquivo);
  }
  //migrating or not, we need to update the version (if its the same it will only match)
  $conn->query('update config set valor = "'.getenv("VERSION").'" where chave = "version";');
  echo "Ok\n";
}
else {
  echo "Setting DB Schema: ";
  $conn->exec(file_get_contents('/var/www/html/src/Novosga/Install/sql/create/'.getenv("DATABASE_SGDB").'.sql'));
  echo "Ok\n";

  echo "Installing modules: ";
  $moddir = "/var/www/html/modules/sga/";
  $modules = array_diff(scandir($moddir), array('.', '..'));
  
  foreach ($modules as $module) {
    exec("php /var/www/html/bin/novosga.php module:install ".$moddir.$module." sga.".$module);
  }
  $conn->query('update modulos set status = 1');
  echo "Ok\n";
   

  echo "Inserting default data: ";
  $adm['login'] = getenv("NOVOSGA_ADMIN_USERNAME");
  $adm['nome'] = getenv("NOVOSGA_ADMIN_FIRSTNAME");
  $adm['sobrenome'] = getenv("NOVOSGA_ADMIN_LASTNAME");
  $adm['senha'] = md5(getenv("NOVOSGA_ADMIN_PASSWORD"));

  $sql = format(file_get_contents('/var/www/html/src/Novosga/Install/sql/data/default.sql'), $adm);
 
  $conn->exec($sql);
  $conn->query('insert into config (chave, valor, tipo) values ("version",  "'.getenv("VERSION").'", 1)');
  echo "Ok\n";
}

?>
