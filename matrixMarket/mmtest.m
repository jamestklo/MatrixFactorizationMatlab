function [A] = mmtest()
	filepath = '../../climf/EP25_UPL5_train.mtx';
	[rows, cols, entries, rep, field, symm] = mminfo(filepath);
	[A, rows, cols, entries] = mmread(filepath);
end
