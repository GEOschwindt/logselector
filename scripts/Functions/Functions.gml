function GetLog(_ref) {
    var search = string(_ref);
    var results = [];
    
    global.Buscando = true;

    var _logPath = working_directory + "logs\\";
    var _savePath = working_directory + "saved\\resultado.txt";

    if (!directory_exists(_logPath)) {
        directory_create(_logPath);
    }
    if (!directory_exists(working_directory + "saved\\")) {
        directory_create(working_directory + "saved\\");
    }

    var file_list = ds_list_create();
    var f = file_find_first(_logPath + "*.txt", fa_none);
    if (f != "") {
        repeat (1) {
            ds_list_add(file_list, f);
            var next_file = file_find_next();
            if (next_file == "") break;
            f = next_file;
        }
        file_find_close();
    }

    if (ds_list_empty(file_list)) {
        global.Error = true;
        global.ErrorMessage = "Nenhum arquivo .txt encontrado na pasta logs";
        ds_list_destroy(file_list);
        global.Buscando = false;
        return results;
    }

    for (var i = 0; i < ds_list_size(file_list); i++) {
        var filename = file_list[| i];
        var full_path = _logPath + filename;

        array_push(results, "--- " + filename + " ---");

        var file = file_text_open_read(full_path);
        var jsonBuffer = "";
        var braceCount = 0;

        while (!file_text_eof(file)) {
            var line = file_text_read_string(file);
            file_text_readln(file);

            jsonBuffer += line + "\n";

            for (var j = 1; j <= string_length(line); j++) {
                var ch = string_char_at(line, j);
                if (ch == "{") braceCount++;
                if (ch == "}") braceCount--;
            }

            if (braceCount == 0 && string_length(string_trim(jsonBuffer)) > 0) {
                if (string_pos(search, jsonBuffer) > 0) {
                    array_push(results, jsonBuffer);    
                }
                jsonBuffer = "";
            }
        }
        file_text_close(file);
    }

    ds_list_destroy(file_list);

    var oldSave = _savePath;
    var countFile = 1;
    while (file_exists(_savePath)) {
        _savePath = string_replace(oldSave, ".txt", " (" + string(countFile) + ").txt");
        countFile++;
    }

    var fo = file_text_open_write(_savePath);
    for (var j = 0; j < array_length(results); j++) {
        file_text_write_string(fo, results[j]);
        file_text_writeln(fo);
    }
    file_text_close(fo);

    global.Buscando = false;
    return results;
}
