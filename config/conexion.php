<?php
    //TODO: Inicia o reanuda una sesión de PHP.
    session_start();

    //TODO: Se define la clase "Conectar".
    class Conectar{

        //TODO: Variable protegida para almacenar la conexión a la base de datos.
        protected $dbh;

        //TODO: Función para realizar la conexión a la base de datos.
        protected function Conexion(){
            try {
                //TODO: Se establece la conexión a la base de datos usando PDO.
                $conectar = $this->dbh = new PDO("mysql:local=localhost;dbname=cotizador","root","");
                //TODO: Se retorna el objeto PDO con la conexión establecida.
                return $conectar;
            } catch (Exception $e) {
                //TODO: Si ocurre un error durante la conexión, se muestra el mensaje de error y se termina el script.
                print "¡Error BD!: " . $e->getMessage() . "<br/>";
                die();
            }
        }

        //TODO: Función para configurar la codificación de caracteres.
        public function set_names(){
            //TODO: Se ejecuta la consulta para configurar la codificación de caracteres a "utf8".
            return $this->dbh->query("SET NAMES 'utf8'");
        }

        //TODO: Función para obtener la ruta de la aplicación.
        public static function ruta(){
            //TODO: Se retorna la ruta de la aplicación en el servidor web.
            return "http://localhost/Cotizacion_Cliente/";
        }

    }
?>