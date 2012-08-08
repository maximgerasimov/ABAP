READ TABLE lt_partner ASSIGNING <ls_partner>
                      WITH KEY partner_fct = lc_manager_fct.
IF sy-subrc = 0.
  lv_partner = <ls_partner>-partner_no.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = lv_partner
    IMPORTING
      output = lv_partner.

  CALL FUNCTION 'RH_STRUC_GET'
    EXPORTING
      act_otype       = 'BP'
      act_objid       = lv_partner
      act_wegid       = 'BP-CP-O'
      authority_check = ''
    TABLES
      result_tab      = lt_result_tab
    EXCEPTIONS
      no_plvar_found  = 1
      no_entry_found  = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
  ENDIF.

  READ TABLE lt_result_tab INTO ls_result_tab
                             WITH KEY otype = 'O'.
  IF sy-subrc = 0.
    CLEAR lt_result_tab.

    lv_boss_bp = ls_result_tab-objid.

    CALL FUNCTION 'RH_STRUC_GET'
      EXPORTING
        act_otype      = 'O'
        act_objid      = lv_boss_bp
        act_wegid      = 'BOSSONLY'
      TABLES
        result_objec   = lt_result_objec
      EXCEPTIONS
        no_plvar_found = 1
        no_entry_found = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
    ENDIF.

    READ TABLE lt_result_objec INTO ls_result_objec
                               WITH KEY otype = 'CP'.
*this is test