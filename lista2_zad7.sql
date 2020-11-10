DELIMITER $$

create or replace procedure random_utwor (IN Nalbum varchar(90), IN idZespol INT)
begin
	set @N_ustor = rand()*14+6;
	for i IN 0..@N_ustor do
		set @R_tytul = concat('TestUtwor',Rand()*1000000);
		set @R_czas = (rand()*200 + 100)*1000;
		insert into utwor (tytul,czas,album,zespol) values (@R_tytul,@R_czas,Nalbum,idZespol);
	end for;
end $$

create or replace procedure random_album(IN ANumber INT) begin 
	if ANumber < 0 then
		select 'Error: number < 0';
	else 
		for i IN 0..ANumber DO
			if RAND() > 0.5 then -- use existed
				set @seed = (RAND()*100000) DIV 2;
				set @name = concat('TestAlbum',@seed);
				select gatunek into @genreName from album order by RAND() limit 1;
				select id into @idZ from zespol order by RAND() limit 1;
				insert into album (tytul,gatunek,zespol) values (@name,@genreName,@idZ);
				call random_utwor(@name,@idZ);
			else
				select 'hh';
				set @zespolName = concat('TestZespol',Rand()*1000000);
				insert into zespol(nazwa) values (@zespolName);
				set @idZ = LAST_INSERT_ID();
				set @seed = (RAND()*100000) DIV 2;
				set @name = concat('TestAlbum',@seed);
				select gatunek into @genreName from album order by RAND() limit 1;
				insert into album (tytul,gatunek,zespol) values (@name,@genreName,@idZ);
				call random_utwor(@name,@idZ);
			end if;
		end for;
	end if;
end $$

DELIMITER ;
