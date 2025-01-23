$(document).ready(function(){

    KTCalendarBasic.init();

    $.ajax({
        url: "../../controller/contacto.php?op=timelineporcontacto",
        type: "GET",
        dataType: "html",
        beforeSend: function() {

        },
        success: function(data) {
            $("#listtimeline").html(data);
        },
        error: function() {

        }
    });

    $.ajax({
        url: "../../controller/contacto.php?op=aceptada",
        type: "GET",
        dataType: "json",
        beforeSend: function() {

        },
        success: function(data) {
            $("#lblaceptada").html(data);
        },
        error: function() {

        }
    });

    $.ajax({
        url: "../../controller/contacto.php?op=rechazado",
        type: "GET",
        dataType: "json",
        beforeSend: function() {

        },
        success: function(data) {
            $("#lblrechazado").html(data);
        },
        error: function() {

        }
    });

    $.ajax({
        url: "../../controller/contacto.php?op=pendiente",
        type: "GET",
        dataType: "json",
        beforeSend: function() {

        },
        success: function(data) {
            $("#lblpendiente").html(data);
        },
        error: function() {

        }
    });

});

var KTCalendarBasic = function() {

    return {
        //main function to initiate the module
        init: function() {
            var todayDate = moment().startOf('day');
            var YM = todayDate.format('YYYY-MM');
            var YESTERDAY = todayDate.clone().subtract(1, 'day').format('YYYY-MM-DD');
            var TODAY = todayDate.format('YYYY-MM-DD');
            var TOMORROW = todayDate.clone().add(1, 'day').format('YYYY-MM-DD');

            $('#data_calendar').fullCalendar({
                isRTL: KTUtil.isRTL(),
                header: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'month,agendaWeek,agendaDay,listWeek'
                },
                editable: true,
                eventLimit: true, // allow "more" link when too many events
                navLinks: true,
                events: {
                    url:'../../controller/contacto.php?op=calendar'
                },
                eventClick: function(calEvent, jsEvent, view) {
                    //TODO: Obtener el ID del evento al hacer clic
                    var eventId = calEvent.id;

                    //TODO: Haz lo que desees con el ID del evento, por ejemplo, mostrarlo en una alerta
                    //TODO Construir la URL con el ID del evento
                    var url = 'http://localhost/Cotizacion_Cliente/view/ViewCotizacion/?id=' + eventId;

                    // Abrir la URL en una nueva pestaña
                    window.open(url, '_blank');
                },
                eventRender: function(event, element) {
                    if (element.hasClass('fc-day-grid-event')) {
                        element.data('content', event.description);
                        element.data('placement', 'top');
                        KTApp.initPopover(element);
                    } else if (element.hasClass('fc-time-grid-event')) {
                        element.find('.fc-title').append('<div class="fc-description">' + event.description + '</div>'); 
                    } else if (element.find('.fc-list-item-title').lenght !== 0) {
                        element.find('.fc-list-item-title').append('<div class="fc-description">' + event.description + '</div>'); 
                    }
                }
            });
        }
    };
}();