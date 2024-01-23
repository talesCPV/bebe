-- DROP PROCEDURE sp_login;
DELIMITER $$
	CREATE PROCEDURE sp_login(
		IN Iemail varchar(70),
		IN Ihash varchar(77)
    )
	BEGIN
		SELECT COUNT(*) AS login, IFNULL(nome,0) AS nome,  IFNULL(id,0) AS id, IFNULL(access,0) AS access FROM tb_usuario WHERE email COLLATE utf8_general_ci = Iemail COLLATE utf8_general_ci AND  hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1;
	END $$
DELIMITER ;

CALL sp_login("talescd@gmail.com","L,$@)6zDJh,T$^6rh)8Tz@B=`&j0t:~D+N5X?b(l2v<#F-P7ZAd*n4x>%H/R9¨­f,p6z@'J1T;^$h");

 DROP PROCEDURE sp_setUser;
DELIMITER $$
	CREATE PROCEDURE sp_setUser(
		IN Iid int(11),
		IN Iemail varchar(70),
		IN Ihash varchar(77),
		IN Inome varchar(15)
    )
	BEGIN
    
		SET @edit = (SELECT COUNT(*) FROM tb_usuario WHERE id=Iid);
        
		IF(@edit) THEN
			UPDATE tb_usuario SET email=Iemail, nome=Inome, hash=Ihash WHERE id=Iid;
			SELECT 1 AS OK;
		ELSE
			SET @qtd_before = (SELECT COUNT(*) FROM tb_usuario);
			INSERT INTO tb_usuario (email,hash,nome) VALUES (Iemail,Ihash,Inome);
			IF((SELECT COUNT(*) FROM tb_usuario) > @qtd_before) THEN
				SELECT 1 AS OK;
			ELSE
				SELECT 0 AS OK;
			END IF;
        END IF;

	END $$
DELIMITER ;

 DROP PROCEDURE sp_do;
DELIMITER $$
	CREATE PROCEDURE sp_do(
		IN Ihash varchar(77),
        IN Iid_bebe int(11),
		IN Iid_modal int(11),
		IN Iobs varchar(256)
    )
	BEGIN
    
		SET @id_call =  IFNULL((SELECT id FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1),0);
	
		INSERT INTO tb_do (id_owner,id_modal,id_bebe,obs) VALUES ( @id_call,Iid_modal,Iid_bebe,Iobs);
        
		SELECT * FROM tb_do WHERE id_modal=Iid_modal AND id_owner = @id_call AND id_bebe= Iid_bebe 
			AND dia >= CURDATE() - INTERVAL 21 DAY - (IF(WEEKDAY(CURDATE())+1<7, WEEKDAY(CURDATE())+1, 0))
			AND dia <= CURDATE() + (6 - IF(WEEKDAY(CURDATE())+1<7, WEEKDAY(CURDATE())+1, 0))
			ORDER BY dia DESC;
            
	END $$
DELIMITER ;


 DROP PROCEDURE sp_view_do;
DELIMITER $$
	CREATE PROCEDURE sp_view_do(
		IN Ihash varchar(77),
        IN Imodal int(11),
        IN Ibebe int(11)
    )
	BEGIN
    
		SET @id_call = (SELECT id FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
				
		SELECT * FROM tb_do WHERE id_modal=Imodal AND id_owner = @id_call AND id_bebe = Ibebe 
			AND dia >= CURDATE() - INTERVAL (21 +  (IF(WEEKDAY(CURDATE())+1<7, WEEKDAY(CURDATE())+1, 0))) DAY
			AND dia <= CURDATE() +  INTERVAL(7 - IF(WEEKDAY(CURDATE())+1<7, WEEKDAY(CURDATE())+1, 0)) DAY
			ORDER BY dia DESC;
	END $$
DELIMITER ;

CALL sp_view_do("f'lB9$rN`<'~l<$Z<9*~rBHT$rB3`0~N?l<-Z*xH9f6'T$rB3`0~N?l<-Z*xH9f6'T$rB3`0~N?l<",1,1);

DROP PROCEDURE sp_viewModal;
DELIMITER $$
	CREATE PROCEDURE sp_viewModal(
		IN Ihash varchar(77),
		IN allmodal boolean
    )
	BEGIN    
		SET @id_call =  IFNULL((SELECT id FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1),0);
        IF(@id_call>0)THEN
			IF(allmodal)THEN
				SELECT * FROM tb_modal WHERE id_user = @id_call;
			ELSE
				SELECT MODAL.* 
				FROM tb_modal AS MODAL
				INNER JOIN tb_my_modal AS MYMOD
				ON MODAL.id=MYMOD.id_modal
                AND MODAL.id_user = MYMOD.id_user
				AND MYMOD.id_user = @id_call;
			END IF;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE sp_view_dia;
DELIMITER $$
	CREATE PROCEDURE sp_view_dia(
		IN Ihash varchar(77),
        IN Imodal int(11),
        IN Ibebe int(11),
        IN Idia date
    )
	BEGIN
    
		SET @id_call =  IFNULL((SELECT id FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1),0);

		IF(@id_call > 0)THEN
			SELECT * FROM tb_do WHERE id_modal=Imodal AND id_owner = @id_call AND id_bebe = Ibebe 
				AND dia >= CONCAT(Idia, " 00:00:00")
				AND dia <= CONCAT(Idia, " 23:59:59")
				ORDER BY dia ASC;
        
        END IF;
				
	END $$
DELIMITER ;

 DROP PROCEDURE sp_addBebe;
DELIMITER $$
	CREATE PROCEDURE sp_addBebe(
		IN Ihash varchar(77),
        IN Iid_bebe int(11),
		IN Inome varchar(50),
		IN Iborn datetime,
        IN Isexo boolean
    )
	BEGIN
    
		SET @id_call =  IFNULL((SELECT id FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1),0);
        
        UPDATE tb_bebe SET sel=0 WHERE id_user=@id_call;
        
		IF(Iid_bebe = 0)THEN
			INSERT INTO tb_bebe (id_user,nome,born,sexo,sel) VALUES ( @id_call,Inome,Iborn,Isexo,1);
		ELSE
			UPDATE tb_bebe SET nome=Inome, born=Iborn, sexo=Isexo, sel=1 WHERE id=Iid_bebe;
        END IF;
                
		SELECT * FROM tb_bebe WHERE id_user = @id_call ORDER BY nome;
	END $$
DELIMITER ;

 DROP PROCEDURE sp_selBebe;
DELIMITER $$
	CREATE PROCEDURE sp_selBebe(
		IN Ihash varchar(77),
        IN Iid_bebe int(11)
    )
	BEGIN
    
		SET @id_call =  IFNULL((SELECT id FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1),0);
        
		IF(Iid_bebe > 0 AND @id_call > 0)THEN
			UPDATE tb_bebe SET sel=0 WHERE id_user=@id_call;
			UPDATE tb_bebe SET sel=1 WHERE id_user=@id_call AND id = Iid_bebe;
        END IF;
                
		SELECT * FROM tb_bebe WHERE id_user = @id_call ORDER BY nome;
	END $$
DELIMITER ;


SELECT MODAL.* 
            FROM tb_modal AS MODAL
            INNER JOIN tb_my_modal AS MYMOD
            ON MODAL.id=MYMOD.id_modal
            AND MYMOD.id_user = 1;