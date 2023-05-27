*& Report Z_J_TESTGPT
*&---------------------------------------------------------------------*
*& REPORT TO TEST OPEN AI API USING THE CLASS ZCL_J_OPENAI
*& CREATED BY JOAQUÍN ERENAS | 27-05-2023
*&---------------------------------------------------------------------*
REPORT Z_J_TESTGPT.

DATA: lo_openAI TYPE REF TO zcl_j_openai,
      resultado type string.

PARAMETERS peti type string.

lo_openai = new zcl_j_openai( ).

resultado = lo_openai->crearpeticion(
gv_peticion = peti ).

MESSAGE resultado type 'I'.