function Globals(){
	global.ErrorMessage = "";
	global.Error = false;
	global.Buscando = false;
	
	// Variáveis para busca assíncrona
	global.SearchState = 0; // 0 = parado, 1 = iniciando, 2 = processando, 3 = finalizando
	global.SearchTerm = "";
	global.FileList = -1; // ds_list com arquivos para processar
	global.CurrentFileIndex = 0;
	global.SearchResults = [];
	global.LogPath = "";
	global.SavePath = "";
	global.FoundInCurrentFile = false;
	global.CurrentFile = "";
	global.StartTime = 0;
}