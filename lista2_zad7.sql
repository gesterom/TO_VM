DELIMITER $$

create or replace procedure random_utwor(in @N_album varchar, IN @idZespol INT)
begin
	set @N_ustor = rand()*14+6;
	for i IN 0..@N_ustor do
		set @R_tytul = concat('TestUtwor',Rand()*1000000);
		set @R_czas = rand()*200 + 100;
		insert into utwor (tytul,czas,album,zespol) values (@R_tytul,@R_czas,@N_album,@idZespol);
	end for;
end $$

create or replace procedure random_album(IN @number INT)

if @number < 0 then
	select 'Error: number < 0';
else 
	begin
		if RAND() > 0.5 -- use existed
			begin
				set @seed INT = RAND()*100000;
				set @name = concat('TestAlbum',@seed);
				select gatunek into @genreName from album order by RAND() limit 1;
				select id into @idZ from zespol order by RAND() limit 1;
				insert into album (tytul,gatunek,zespol) values (@name,@genreName,@idZ);
				call random_utwor(@name,@idZ);
			end
		else -- create new
			begin
				set @zespolName = concat('TestZespol',Rand()*1000000);
				insert into zespol(nazwa) values (@zespolName);
				set @idZ = LAST_INSERT_ID();
				set @seed INT = RAND()*100000;
				set @name = concat('TestAlbum',@seed);
				select gatunek into @genreName from album order by RAND() limit 1;
				insert into album (tytul,gatunek,zespol) values (@name,@genreName,@idZ);
				call random_utwor(@name,@idZ);
			end
		end if
	end 
end if

DELIMITER ;
