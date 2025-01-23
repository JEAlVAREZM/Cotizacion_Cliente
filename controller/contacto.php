<?php
    //TODO: Se incluyen los archivos necesarios
    require_once("../config/conexion.php");
    require_once("../models/Contacto.php");

    //TODO: Se crea una instancia de la clase Cotizacion
    $contacto = new Contacto();

    //TODO: Se utiliza un switch para determinar qué acción realizarget_cotizacion_x_contacto()
    switch($_GET["op"]){
        case "listarporcontacto":
            $datos=$contacto->get_cotizacion_x_contacto($_SESSION["con_id"]);
           //$data=$datos;
            $data=Array();
            foreach($datos as $row){
                $sub_array = array();
                $sub_array[] = $row["cot_id"];
                $sub_array[] = $row["cli_nom"];
                $sub_array[] = $row["cli_rut"];
                $sub_array[] = $row["con_nom"];
                $sub_array[] = $row["con_email"];
                $sub_array[] = $row["cot_total"];
                $sub_array[] = $row["fech_crea"];
                if($row["cot_tipo"]=='Rechazado'){
                    $sub_array[] = "<span class='kt-badge kt-badge--danger kt-badge--inline kt-badge--pill'>Rechazado</span>";
                }else if($row["cot_tipo"]=='Aceptado'){
                    $sub_array[] = "<span class='kt-badge kt-badge--success kt-badge--inline kt-badge--pill'>Aceptado</span>";
                }else if($row["cot_tipo"]=='Pendiente'){
                    $sub_array[] = "<span class='kt-badge kt-badge--focus kt-badge--inline kt-badge--pill'>Pendiente</span>";
                }else if($row["cot_tipo"]=='Enviado'){
                    $sub_array[] = "<span class='kt-badge kt-badge--warning kt-badge--inline kt-badge--pill'>Enviado</span>";
                }

                $sub_array[] = '<a href="http://localhost/Cotizador%20en%20linea/view/ViewCotizacion/?id='.$row["cot_id"].'" target="_blank" class="btn btn-outline-brand btn-sm btn-elevate btn-icon"><i class="fas fa-eye"></i></a>';
                $data[] = $sub_array;
            }

            //TODO: Se prepara la respuesta en formato JSON
            $results = array(
                "sEcho"=>1,
                "iTotalRecords"=>count($data),
                "iTotalDisplayRecords"=>count($data),
                "aaData"=>$data);

            echo json_encode($results);
            break;

        case "timelineporcontacto":
            $datos=$contacto->get_cotizacion_x_contacto($_SESSION["con_id"]);
            foreach($datos as $row){
                ?>
                    <div class="kt-timeline__item kt-timeline__item--<?php echo $row["cot_color"]?>">
                        <div class="kt-timeline__item-section">
                            <div class="kt-timeline__item-section-border">
                                <div class="kt-timeline__item-section-icon"> <i class="flaticon2-pie-chart-4 kt-font-<?php echo $row["cot_color"]?>"></i> </div>
                            </div>
                            <span class="kt-timeline__item-datetime"><?php echo $row["fech_formateada_envio"]?></span>
                        </div>
                        <a href="http://localhost/Cotizador%20en%20linea/view/ViewCotizacion/?id=<?php echo $row["cot_id"]?>" target="_blank" class="kt-timeline__item-text"> <span class='kt-badge kt-badge--<?php echo $row["cot_color"]?> kt-badge--inline kt-badge--pill'><?php echo $row["cot_tipo"]?></span> - Cotización para el cliente <?php echo $row["cli_nom"]?> y su contacto <?php echo $row["con_nom"]?></a> 
                        <div class="kt-timeline__item-info"> Cotización Nro: <?php echo $row["cot_id"]?>  </div>
                    </div>
                <?php
            }
            break;

        case "aceptada":
            $datos=$contacto->get_cotizacion_x_aceptada($_SESSION["con_id"]);
            echo json_encode($datos[0]["total"]);
            break;

        case "rechazado":
            $datos=$contacto->get_cotizacion_x_rechazado($_SESSION["con_id"]);
            echo json_encode($datos[0]["total"]);
            break;

        case "pendiente":
            $datos=$contacto->get_cotizacion_x_pendiente($_SESSION["con_id"]);
            echo json_encode($datos[0]["total"]);
            break;

        case "calendar":
            $datos=$contacto->get_cotizacion_calendario($_SESSION["con_id"]);
            echo json_encode($datos);
            break;
    }
    ?>