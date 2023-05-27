*&---------------------------------------------------------------------*
*& REPORT TO CREATE OBJET TO USE OPEN AI API
*& CREATED BY JOAQUÍN ERENAS | 27-05-2023
*&---------------------------------------------------------------------*

CLASS zcl_j_openai DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS crearPeticion """ Este método servirá para realizar la petición a la IA
      IMPORTING gv_peticion type string """ En esta variable estará almacenado lo que solicitaremos a la IA
      RETURNING VALUE(lv_resultado) TYPE string. """ Esta será la variable que contendrá la info obtenida

  PROTECTED SECTION.
  PRIVATE SECTION.


ENDCLASS.



CLASS zcl_j_openai IMPLEMENTATION.


  METHOD crearPeticion.
    """""" CREAR EL CLIENTE PARA REALIZAR LA PETICIÓN
    cl_http_client=>create_by_url(
  EXPORTING
    url                = 'https://api.openai.com/v1/chat/completions'
  IMPORTING
    client             = DATA(lo_cliente_obj) " CREAREMOS UN OBJETO LOCAL GRACIAS AL MÉTODO EMPLEADO
  EXCEPTIONS
    argument_not_found = 1
    plugin_not_active  = 2
    internal_error     = 3
    OTHERS             = 4 ).

    """ A CONTINUACIÓN SE CREARA UNA VARIABLE CON EL MODELO DE PETICIÓN A LA URL
    DATA(modelo) = '{ "model": "gpt-3.5-turbo","messages":[{"role": "user","content": "' && gv_peticion && '"}]}'.

    """ CREAREMOS LA PETICIÓN, ESTA DEBE SER DE TIPO 'POST'
    lo_cliente_obj->request->set_method( if_http_request=>co_request_method_post ).

    """ AHORA ESTABLECEMOS LOS PARÁMETROS DE AUTENTICACIÓN NECESARIOS | EL USUARIO NO ES OBLIGATORIO
    lo_cliente_obj->request->set_authorization(
        username = ''
        password = 'TU CLAVE API'
        ).

    """ LUEGO PONEMOS EL TIPO DE CONTENIDO QUE RECIBIREMOS DE LA PETICIÓN, EN ESTE CASO SERÁ JSON
    lo_cliente_obj->request->set_content_type('application/json').

    """ FINALMENTE APLICAMOS EL MODELO DE PETICIÓN CREADO ANTERIORMENTE
    lo_cliente_obj->request->set_cdata( modelo ).

    TRY.
        """ UNA VEZ APLICADOS LOS PARÁMETROS ANTERIORES ENVIAMOS LA PETICIÓN
        lo_cliente_obj->send(  ).

        """ RECIBIMOS LOS DATOS DE LA PETICIÓN | AL SER UNA DEMOSTRACIÓN PEQUEÑA NO SE ESTÁ HACIENDO USO DE LAS EXCEPCIONES DE CADA MÉTODO
        lo_cliente_obj->receive(  ).

        """ GUARDAMOS LOS DATOS RECIBIMOS DE LA PETICIÓN EN LA VARIABLE QUE CREAMOS A CONTINUACIÓN
        DATA(ld_stream) = lo_cliente_obj->response->get_cdata( ).

        """ AHORA A TRAVÉS DEL USO DE SPLIT RECORTAREMOS LOS DATOS HASTA OBTENER EL TEXTO LEGIBLE PARA EL USUARIO

        DATA: lv_pre_resultado TYPE string.

        SPLIT ld_stream AT '"content":"' INTO: lv_pre_resultado lv_resultado. """ SACAMOS LOS DATOS QUE VAN DESPUÉS DE 'CONTENT'
        SPLIT lv_resultado AT '"' INTO: lv_resultado lv_pre_resultado. """ AQUÍ SE GUARDARÁN LOS DATOS QUE SE RETORARÁN AL USUARIO

        """ CERRAMOS LA CONEXIÓN DEL OBJETO CLIENTE
        lo_cliente_obj->close(  ).

      CATCH cx_root INTO DATA(cx_msg).
        MESSAGE 'Error: ' && cx_msg->get_text(  ) TYPE 'I'.
    ENDTRY.




  ENDMETHOD.

ENDCLASS.
