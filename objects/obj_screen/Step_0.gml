///INPUTS
if (selectInputPathLogs) {
	if (keyboard_string != "") {
		inputPathLogs += keyboard_string;
		keyboard_string = "";
	}
	
	if (keyboard_check_pressed(vk_backspace) && string_length(inputPathLogs) > 0) {
		inputPathLogs = string_delete(inputPathLogs, string_length(inputPathLogs), 1);	
	}
	
	if (keyboard_check(vk_control) && keyboard_check_pressed(ord("V"))) {
		var clip = clipboard_get_text();
		if (is_string(clip)) {
			inputPathLogs += clip;
			
			if (string_length(inputPathLogs) > maxInputPathLogs) {
				inputPathLogs = string_copy(inputPathLogs, 1, maxInputPathLogs);	
			}
		}
	}
}
if (selectInputPathSave) {
	if (keyboard_string != "") {
		inputPathSave += keyboard_string;
		keyboard_string = "";
	}
	
	if (keyboard_check_pressed(vk_backspace) && string_length(inputPathSave) > 0) {
		inputPathSave = string_delete(inputPathSave, string_length(inputPathSave), 1);	
	}
	
	if (keyboard_check(vk_control) && keyboard_check_pressed(ord("V"))) {
		var clip = clipboard_get_text();
		if (is_string(clip)) {
			inputPathSave += clip;
			
			if (string_length(inputPathSave) > maxInputPathSave) {
				inputPathSave = string_copy(inputPathSave, 1, maxInputPathSave);	
			}
		}
	}
}
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

// SCROLL DA JANELA DE RESULTADOS
if (array_length(jsonFilter) > maxVisibleLines) {
    var scrollSpeed = 3;
    
    // Scroll com mouse wheel
    if (mouse_wheel_up()) {
        scrollOffset = max(0, scrollOffset - scrollSpeed);
        surfaceNeedsUpdate = true;
    }
    if (mouse_wheel_down()) {
        var maxScroll = array_length(jsonFilter) - maxVisibleLines;
        scrollOffset = min(maxScroll, scrollOffset + scrollSpeed);
        surfaceNeedsUpdate = true;
    }
    
    // Scroll com teclado (setas)
    if (keyboard_check_pressed(vk_up)) {
        scrollOffset = max(0, scrollOffset - 1);
        surfaceNeedsUpdate = true;
    }
    if (keyboard_check_pressed(vk_down)) {
        var maxScroll = array_length(jsonFilter) - maxVisibleLines;
        scrollOffset = min(maxScroll, scrollOffset + 1);
        surfaceNeedsUpdate = true;
    }
}

// MOUSE
if (mouse_check_button_pressed(mb_left)) {
    var mx = mouse_x;
    var my = mouse_y;
    
    if (mx >= inputPathLogsX && mx <= inputPathLogsX + inputWidth && 
        my >= inputPathLogsY && my <= inputPathLogsY + inputHeight) {
        selectInputPathLogs = true;
        selectInputPathSave = false;
        selectInputReference = false;
    }
    else if (mx >= inputPathSaveX && mx <= inputPathSaveX + inputWidth && 
             my >= inputPathSaveY && my <= inputPathSaveY + inputHeight) {
        selectInputPathLogs = false;
        selectInputPathSave = true;
        selectInputReference = false;
    }
    else if (mx >= inputReferenceX && mx <= inputReferenceX + inputWidth && 
             my >= inputReferenceY && my <= inputReferenceY + inputHeight) {
        selectInputPathLogs = false;
        selectInputPathSave = false;
        selectInputReference = true;
    }
    else if (mx >= buttonBuscarX && mx <= buttonBuscarX + buttonWidth && 
             my >= buttonBuscarY && my <= buttonBuscarY + buttonHeight) {
        jsonFilter = GetLog(inputReference);
        scrollOffset = 0; // Reset scroll quando nova busca
        surfaceNeedsUpdate = true; // Precisa atualizar a surface
    }
    else if (mx >= buttonLimparX && mx <= buttonLimparX + buttonWidth && 
             my >= buttonLimparY && my <= buttonLimparY + buttonHeight) {
        inputPathLogs = "";
        inputPathSave = "";
        inputReference = "";
        jsonFilter = []; // Limpar resultados também
        scrollOffset = 0;
        surfaceNeedsUpdate = true; // Precisa atualizar a surface
		
        selectInputPathLogs = false;
        selectInputPathSave = false;
        selectInputReference = false;
    }
    else {
        selectInputPathLogs = false;
        selectInputPathSave = false;
        selectInputReference = false;
    }
}