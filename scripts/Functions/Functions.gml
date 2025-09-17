function GetLog(_ref) {
    var search = string(_ref);
    
    // Validação de entrada
    if (string_length(search) == 0) {
        global.Error = true;
        global.ErrorMessage = "Referência não pode estar vazia";
        global.Buscando = false;
        return [];
    }
    
    // Iniciar busca assíncrona
    global.SearchState = 1; // Estado: iniciando
    global.SearchTerm = search;
    global.Buscando = true;
    global.StartTime = get_timer();
    
    // Inicializar variáveis de progresso
    global.ProgressoTotal = 0;
    global.ProgressoAtual = 0;
    global.ProgressoTexto = "Iniciando busca...";
    global.SearchResults = [];

    var _logPath = working_directory + "logs\\";
    var _savePath = working_directory + "saved\\resultado.txt";

    if (!directory_exists(_logPath)) {
        directory_create(_logPath);
    }
    if (!directory_exists(working_directory + "saved\\")) {
        directory_create(working_directory + "saved\\");
    }

    global.LogPath = _logPath;
    global.SavePath = _savePath;

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
        global.SearchState = 0;
        return [];
    }
    
    // Configurar progresso total
    global.ProgressoTotal = ds_list_size(file_list);
    global.ProgressoAtual = 0;
    global.ProgressoTexto = "Verificando arquivos...";
    
    // Armazenar lista de arquivos globalmente
    global.FileList = file_list;
    global.CurrentFileIndex = 0;
    
    // Iniciar processamento
    global.SearchState = 2; // Estado: processando
    
    return [];
}

function ProcessNextFile() {
    if (global.SearchState != 2) return;
    
    // Verificar se ainda há arquivos para processar
    if (global.CurrentFileIndex >= ds_list_size(global.FileList)) {
        // Finalizar busca
        FinishSearch();
        return;
    }
    
    var filename = ds_list_find_value(global.FileList, global.CurrentFileIndex);
    var full_path = global.LogPath + filename;
    
    // Atualizar progresso
    global.ProgressoAtual = global.CurrentFileIndex + 1;
    var percentual = round((global.ProgressoAtual / global.ProgressoTotal) * 100);
    global.ProgressoTexto = "Verificando: " + filename + " (" + string(percentual) + "%)";
    
    // Adicionar cabeçalho do arquivo
    array_push(global.SearchResults, "--- " + filename + " ---");
    
    var file = file_text_open_read(full_path);
    if (file == -1) {
        // Arquivo não pode ser aberto, pular para o próximo
        global.CurrentFileIndex++;
        return;
    }

    // Primeiro, detectar se é um arquivo JSON ou texto simples
    var isJsonFile = DetectFileType(file);
    file_text_close(file);
    
    // Reabrir arquivo para processamento
    file = file_text_open_read(full_path);
    
    global.FoundInCurrentFile = false;
    
    if (isJsonFile) {
        // Processar como arquivo JSON (lógica original)
        ProcessJsonFile(file);
    } else {
        // Processar como arquivo de texto simples
        ProcessTextFile(file);
    }
    
    file_text_close(file);
    
    // Se não encontrou nada neste arquivo, remover o cabeçalho
    if (!global.FoundInCurrentFile && array_length(global.SearchResults) > 0) {
        array_pop(global.SearchResults); // Remove o último elemento (cabeçalho)
    }
    
    // Avançar para o próximo arquivo
    global.CurrentFileIndex++;
}

function DetectFileType(file) {
    // Ler as primeiras linhas para detectar se é JSON
    var jsonIndicators = 0;
    var textIndicators = 0;
    var lineCount = 0;
    var maxLines = 10; // Verificar apenas as primeiras 10 linhas
    
    while (!file_text_eof(file) && lineCount < maxLines) {
        var line = string_trim(file_text_readln(file));
        lineCount++;
        
        if (string_length(line) > 0) {
            // Indicadores de JSON
            if (string_pos("{", line) > 0 || string_pos("}", line) > 0 || 
                string_pos("[", line) > 0 || string_pos("]", line) > 0 ||
                string_pos("\"", line) > 0) {
                jsonIndicators++;
            }
            
            // Indicadores de texto simples
            if (string_pos(":", line) > 0 && string_pos("\"", line) == 0) {
                textIndicators++;
            }
        }
    }
    
    // Se há mais indicadores JSON, é provavelmente um arquivo JSON
    return jsonIndicators > textIndicators;
}

function ProcessJsonFile(file) {
    var jsonBuffer = "";
    var braceCount = 0;
    var currentLine = 0;
    var bodyStartLine = 0;
    var bodyEndLine = 0;

    while (!file_text_eof(file)) {
        var line = file_text_readln(file);
        currentLine++;

        // Se estamos começando um novo corpo JSON
        if (braceCount == 0 && string_length(string_trim(jsonBuffer)) == 0) {
            bodyStartLine = currentLine;
        }

        jsonBuffer += line + "\n";

        // Contar chaves de forma mais eficiente
        var openBraces = string_count("{", line);
        var closeBraces = string_count("}", line);
        braceCount += (openBraces - closeBraces);

        if (braceCount == 0 && string_length(string_trim(jsonBuffer)) > 0) {
            bodyEndLine = currentLine;
            
            if (string_pos(string_upper(global.SearchTerm), string_upper(jsonBuffer)) > 0) {
                // Adicionar informações de linha antes do corpo
                var lineInfo = "Linhas: " + string(bodyStartLine) + " - " + string(bodyEndLine);
                array_push(global.SearchResults, lineInfo);
                array_push(global.SearchResults, jsonBuffer);
                global.FoundInCurrentFile = true;
            }
            jsonBuffer = "";
        }
    }
}

function ProcessTextFile(file) {
    var currentLine = 0;
    
    while (!file_text_eof(file)) {
        var line = file_text_readln(file);
        currentLine++;
        
        // Verificar se a linha contém a referência
        if (string_pos(string_upper(global.SearchTerm), string_upper(line)) > 0) {
            // Adicionar informação da linha e o conteúdo
            var lineInfo = "Linha: " + string(currentLine);
            array_push(global.SearchResults, lineInfo);
            array_push(global.SearchResults, line);
            global.FoundInCurrentFile = true;
        }
    }
}

function FinishSearch() {
    global.SearchState = 3; // Estado: finalizando
    
    // Calcular estatísticas
    var totalFiles = ds_list_size(global.FileList);
    
    // Contar todos os resultados encontrados (JSON e texto)
    var totalResults = 0;
    for (var k = 0; k < array_length(global.SearchResults); k++) {
        var resultLine = global.SearchResults[k];
        // Contar linhas que contêm dados (não cabeçalhos ou informações de linha)
        if (string_pos("--- ", resultLine) == 0 && string_pos("Linha:", resultLine) == 0 && string_pos("Linhas:", resultLine) == 0) {
            totalResults++;
        }
    }
    
    // Calcular tempo de execução
    var endTime = get_timer();
    var executionTime = (endTime - global.StartTime) / 1000000;
    
    // Preparar mensagem final
    var message = "";
    
    if (totalResults > 0) {
        // Salvar arquivo apenas se encontrou resultados
        var oldSave = global.SavePath;
        var countFile = 1;
        var finalSavePath = global.SavePath;
        while (file_exists(finalSavePath)) {
            finalSavePath = string_replace(oldSave, ".txt", " (" + string(countFile) + ").txt");
            countFile++;
        }
        
        var fo = file_text_open_write(finalSavePath);
        for (var j = 0; j < array_length(global.SearchResults); j++) {
            file_text_write_string(fo, global.SearchResults[j]);
            file_text_writeln(fo);
        }
        file_text_close(fo);
        
        message = "Busca concluída!\n";
        message += "Arquivos processados: " + string(totalFiles) + "\n";
        message += "Resultados encontrados: " + string(totalResults) + "\n";
        message += "Tempo de execução: " + string(executionTime) + " segundos\n";
        message += "Arquivo salvo: " + string_replace(finalSavePath, working_directory, "");
    } else {
        message = "Nenhum log encontrado!\n";
        message += "Arquivos processados: " + string(totalFiles) + "\n";
        message += "Tempo de execução: " + string(executionTime) + " segundos\n";
        message += "Termo pesquisado: '" + global.SearchTerm + "'";
    }
    
    // Limpar variáveis globais
    ds_list_destroy(global.FileList);
    global.FileList = -1;
    global.SearchState = 0;
    global.Buscando = false;
    global.ProgressoTexto = "Busca concluída!";
    
    show_message(message);
}