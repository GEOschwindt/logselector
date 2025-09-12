function GetLog(_ref) {
    var search = string(_ref);
    var results = [];
    
    // Validação de entrada
    if (string_length(search) == 0) {
        global.Error = true;
        global.ErrorMessage = "Referência não pode estar vazia";
        global.Buscando = false;
        return results;
    }
    
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
        repeat (1000) { // Aumentar limite para processar todos os arquivos
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
        var filename = ds_list_find_value(file_list, i);
        var full_path = _logPath + filename;

        // Adicionar cabeçalho do arquivo
        array_push(results, "--- " + filename + " ---");

        var file = file_text_open_read(full_path);
        if (file == -1) {
            // Arquivo não pode ser aberto, pular para o próximo
            continue;
        }

        var jsonBuffer = "";
        var braceCount = 0;
        var foundInFile = false; // Flag para verificar se encontrou algo neste arquivo

        while (!file_text_eof(file)) {
            var line = file_text_read_string(file);
            file_text_readln(file);

            jsonBuffer += line + "\n";

            // Contar chaves de forma mais eficiente
            var openBraces = string_count("{", line);
            var closeBraces = string_count("}", line);
            braceCount += (openBraces - closeBraces);

            if (braceCount == 0 && string_length(string_trim(jsonBuffer)) > 0) {
                if (string_pos(search, jsonBuffer) > 0) {
                    array_push(results, jsonBuffer);
                    foundInFile = true;
                }
                jsonBuffer = "";
            }
        }
        file_text_close(file);
        
        // Se não encontrou nada neste arquivo, remover o cabeçalho
        if (!foundInFile && array_length(results) > 0) {
            array_pop(results); // Remove o último elemento (cabeçalho)
        }
    }

    // Calcular estatísticas antes de destruir a lista
    var totalFiles = ds_list_size(file_list);
    var totalResults = array_length(results);
    
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
	
	var fileName = string("resultado (" + string(countFile) + ").txt");
	
    global.Buscando = false;
    
    var message = "Busca concluída!\n";
    message += "Arquivos processados: " + string(totalFiles) + "\n";
    message += "Resultados encontrados: " + string(totalResults) + "\n";
    message += "Arquivo salvo: " + string_replace(_savePath, working_directory, "");
    
    show_message(message);
    return results;
}

