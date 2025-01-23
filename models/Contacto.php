<?php
    class Contacto extends Conectar{

        public function login(){
            //TODO: Establecemos una conexión a la base de datos
            $conectar = parent::conexion();
            //TODO: Configuramos el set de caracteres para evitar problemas de codificación
            parent::set_names();
            // Si el formulario de inicio de sesión se ha enviado
            if (isset($_POST["enviar"])){
                //TODO: Obtenemos el correo y la contraseña enviados por el usuario
                $correo = $_POST["con_email"];
                $pass = $_POST["con_pass"];
                //TODO: Si ambos campos están vacíos
                if(empty($correo) and empty($pass)){
                    //TODO: Redirigimos al usuario de vuelta a la página de inicio de sesión con un mensaje de error
                    header("Location:".conectar::ruta()."index.php?m=2");
                    exit();
                }else{
                    //TODO: Preparamos una consulta SQL para obtener los datos del usuario que intenta iniciar sesión
                    $sql = "CALL cotizador.sp_l_contacto_01(?, ?);";
                    $sql = $conectar->prepare($sql);
                    $sql->bindValue(1, $correo);
                    $sql->bindValue(2, $pass);
                    $sql->execute();
                    //TODO: Obtenemos los resultados de la consulta
                    $resultado = $sql->fetch();
                    //TODO: Si se encontró un usuario con las credenciales proporcionadas
                    if(is_array($resultado) and count($resultado)>0){
                        //TODO: Almacenamos algunos datos del usuario en la sesión
                        $_SESSION["con_id"] = $resultado["con_id"];
                        $_SESSION["con_nom"] = $resultado["con_nom"];
                        $_SESSION["con_email"] = $resultado["con_email"];
                        $_SESSION["cli_id"] = $resultado["cli_id"];
                        $_SESSION["cli_nom"] = $resultado["cli_nom"];
                        //TODO: Redirigimos al usuario a la página de inicio
                        header("Location:".conectar::ruta()."view/Home/");
                        exit();
                    }else{
                        //TODO: Si las credenciales no son válidas, redirigimos al usuario de vuelta a la página de inicio de sesión con un mensaje de error
                        header("Location:".conectar::ruta()."index.php?m=1");
                        exit();
                    }
                }
            }
        }

        public function get_cotizacion_x_contacto($con_id){
            // TODO: Se establece la conexión a la base de datos.
            $conectar = parent::conexion();
            // TODO: Se configura la codificación de caracteres.
            parent::set_names();
            // TODO: Se define la consulta SQL para eliminar una empresa.
            $sql = "CALL sp_l_contacto_02 (?)";
            $sql = $conectar->prepare($sql);
            $sql->bindValue(1, $con_id);
            $sql->execute();
            // TODO: Se obtienen los resultados de la consulta en un arreglo.
            return $resultado = $sql->fetchAll();
        }

        public function get_cotizacion_x_aceptada($con_id){
            // TODO: Se establece la conexión a la base de datos.
            $conectar = parent::conexion();
            // TODO: Se configura la codificación de caracteres.
            parent::set_names();
            // TODO: Se define la consulta SQL para eliminar una empresa.
            $sql = "SELECT COUNT(*) AS total FROM tm_cotizacion 
            WHERE con_id = ?
            and cot_tipo='Aceptado'";
            $sql = $conectar->prepare($sql);
            $sql->bindValue(1, $con_id);
            $sql->execute();
            // TODO: Se obtienen los resultados de la consulta en un arreglo.
            return $resultado = $sql->fetchAll();
        }

        public function get_cotizacion_x_rechazado($con_id){
            // TODO: Se establece la conexión a la base de datos.
            $conectar = parent::conexion();
            // TODO: Se configura la codificación de caracteres.
            parent::set_names();
            // TODO: Se define la consulta SQL para eliminar una empresa.
            $sql = "SELECT COUNT(*) AS total FROM tm_cotizacion 
            WHERE con_id = ?
            and cot_tipo='Rechazado'";
            $sql = $conectar->prepare($sql);
            $sql->bindValue(1, $con_id);
            $sql->execute();
            // TODO: Se obtienen los resultados de la consulta en un arreglo.
            return $resultado = $sql->fetchAll();
        }

        public function get_cotizacion_x_pendiente($con_id){
            // TODO: Se establece la conexión a la base de datos.
            $conectar = parent::conexion();
            // TODO: Se configura la codificación de caracteres.
            parent::set_names();
            // TODO: Se define la consulta SQL para eliminar una empresa.
            $sql = "SELECT COUNT(*) AS total FROM tm_cotizacion 
            WHERE con_id = ?
            and cot_tipo='Visto'";
            $sql = $conectar->prepare($sql);
            $sql->bindValue(1, $con_id);
            $sql->execute();
            // TODO: Se obtienen los resultados de la consulta en un arreglo.
            return $resultado = $sql->fetchAll();
        }

        public function get_cotizacion_calendario($con_id){
            // TODO: Se establece la conexión a la base de datos.
            $conectar = parent::conexion();
            // TODO: Se configura la codificación de caracteres.
            parent::set_names();
            // TODO: Se define la consulta SQL para eliminar una empresa.
            $sql = "CALL sp_l_contacto_03 (?)";
            $sql = $conectar->prepare($sql);
            $sql->bindValue(1, $con_id);
            $sql->execute();
            // TODO: Se obtienen los resultados de la consulta en un arreglo.
            return $resultado = $sql->fetchAll();
        }

    }
?>