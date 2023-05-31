local ziga = false
function main()
	sampAddChatMessage("[ZIGA]{6495ED} Зига успешно загружена. {FFFFFF}Чтобы её кинуть, введите: {F08080}/ziga", 0xF08080)
	sampRegisterChatCommand('ziga', function() ziga = not ziga end)
	while true do
		if ziga then
			taskPlayAnim(PLAYER_PED, "Pointup_loop", "ON_LOOKERS", 12, true, false, false, false, -1)
			sampAddChatMessage("[Ziga] Зига успешно кинута. Чтобы остановить анимку нажми F.")
			if wasKeyPressed(0x46) and not sampIsCursorActive() then
				ziga = false
				clearCharTasks(1)
			end
		end
		wait(0)
	end
end