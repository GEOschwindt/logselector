///INPUTS
if (selectInputReference) {
	if (keyboard_string != "") {
		inputReference += keyboard_string;
		keyboard_string = "";
	}
	
	if (keyboard_check_pressed(vk_backspace) && string_length(inputReference) > 0) {
		inputReference = string_delete(inputReference, string_length(inputReference), 1);	
	}
	
	if (keyboard_check(vk_control) && keyboard_check_pressed(ord("V"))) {
		var clip = clipboard_get_text();
		if (is_string(clip)) {
			inputReference += clip;
			
			if (string_length(inputReference) > maxInputReference) {
				inputReference = string_copy(inputReference, 1, maxInputReference);	
			}
		}
	}
}

// MOUSE
if (mouse_check_button_pressed(mb_left)) {
    var mx = mouse_x;
    var my = mouse_y;
    
    if (mx >= inputReferenceX && mx <= inputReferenceX + (room_width - inputReferenceX) && 
        my >= inputReferenceY && my <= inputReferenceY + inputHeight) {
        selectInputReference = true;
    }
    else if (mx >= buttonBuscarX && mx <= buttonBuscarX + buttonWidth && 
             my >= buttonBuscarY && my <= buttonBuscarY + buttonHeight) {
        GetLog(inputReference);
    }
    else if (mx >= buttonLimparX && mx <= buttonLimparX + buttonWidth && 
             my >= buttonLimparY && my <= buttonLimparY + buttonHeight) {
        inputReference = "";
        selectInputReference = false;
    }
    else {
        selectInputReference = false;
    }
}

// PROCESSAMENTO ASSÍNCRONO DE BUSCA
if (global.SearchState == 2) { // Estado: processando arquivos
    ProcessNextFile();
}