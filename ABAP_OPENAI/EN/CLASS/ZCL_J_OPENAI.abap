*&---------------------------------------------------------------------*
*& REPORT TO CREATE OBJET TO USE OPEN AI API
*& CREATED BY JOAQUÍN ERENAS | 27-05-2023
*&---------------------------------------------------------------------*

CLASS zcl_j_openai DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS createRequest """ This method will be used to make the request to the AI
      IMPORTING gv_request type string """ In this variable will be stored what we will request to the AI
      RETURNING VALUE(lv_result) TYPE string. """ This will be the variable that will contain the information obtained
  PROTECTED SECTION.
  PRIVATE SECTION.


ENDCLASS.



CLASS zcl_j_openai IMPLEMENTATION.


  METHOD createRequest.
    """""" CREATE THE CLIENT TO MAKE THE REQUEST
    cl_http_client=>create_by_url(
  EXPORTING
    url                = 'https://api.openai.com/v1/chat/completions'
  IMPORTING
    client             = DATA(lo_client_obj) " WE WILL CREATE A LOCAL OBJECT THANKS TO THE METHOD USED
  EXCEPTIONS
    argument_not_found = 1
    plugin_not_active  = 2
    internal_error     = 3
    OTHERS             = 4 ).

    """ THEN A VARIABLE WILL BE CREATED WITH THE REQUEST MODEL TO THE URL
    DATA(modelo) = '{ "model": "gpt-3.5-turbo","messages":[{"role": "user","content": "' && gv_peticion && '"}]}'.

    """ WE WILL CREATE THE REQUEST, THIS MUST BE OF TYPE 'POST'
    lo_client_obj->request->set_method( if_http_request=>co_request_method_post ).

    """ NOW WE SET THE NECESSARY AUTHENTICATION PARAMETERS | THE USER IS NOT MANDATORY
    lo_client_obj->request->set_authorization(
        username = ''
        password = 'YOUR API KEY'
        ).

    """ THEN WE PUT THE TYPE OF CONTENT THAT WE WILL RECEIVE FROM THE REQUEST, IN THIS CASE IT WILL BE JSON
    lo_client_obj->request->set_content_type('application/json').

    """ FINALLY, WE APPLY THE PREVIOUSLY CREATED REQUEST MODEL
    lo_client_obj->request->set_cdata( modelo ).

    TRY.
        """ ONCE THE PREVIOUS PARAMETERS HAVE BEEN APPLIED, WE SEND THE REQUEST
        lo_client_obj->send(  ).

        """ WE RECEIVED THE REQUEST DATA | BEING A SMALL DEMONSTRATION, THE EXCEPTIONS OF EACH METHOD ARE NOT BEING USED
        lo_client_obj->receive(  ).

        """ WE SAVE THE DATA WE RECEIVED FROM THE REQUEST IN THE VARIABLE THAT WE CREATE BELOW
        DATA(ld_stream) = lo_client_obj->response->get_cdata( ).

        """ NOW THROUGH THE USE OF SPLIT WE WILL TRIM THE DATA UNTIL OBTAINING THE TEXT READABLE FOR THE USER
        DATA: lv_pre_resultado TYPE string.

        SPLIT ld_stream AT '"content":"' INTO: lv_pre_resultado lv_resultado. """ WE OBTAIN THE DATA THAT GOES AFTER 'CONTENT'
        SPLIT lv_resultado AT '"' INTO: lv_resultado lv_pre_resultado. """ HERE WILL BE STORED THE DATA THAT WILL BE RETURNED TO THE USER

        """ WE CLOSE THE CONNECTION OF THE CLIENT OBJECT
        lo_client_obj->close(  ).

      CATCH cx_root INTO DATA(cx_msg).
        MESSAGE 'Error: ' && cx_msg->get_text(  ) TYPE 'I'.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.