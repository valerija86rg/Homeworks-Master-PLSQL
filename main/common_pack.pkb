create or replace package body common_pack  is 
/*
Автор: Кайгородова В.А. 
Описание пакета: для общих объектов
*/
  g_enable_manual_changes boolean := false; --разрешены ли изменения объектов не через API

  --включение отклчючение разрешения менять вручную данные объектов
  procedure enable_manual_changes
  is
  begin
    g_enable_manual_changes := true;
  end enable_manual_changes;
  
  procedure disable_manual_changes
  is
  begin
    g_enable_manual_changes := false;
  end disable_manual_changes;
  
  --разрешены ли ручные изменения
  function is_manual_changes_allowed return boolean
  is
  begin
    return g_enable_manual_changes;
  end is_manual_changes_allowed;

end common_pack;
/