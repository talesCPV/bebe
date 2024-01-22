-- DROP TABLE tb_usuario;
CREATE TABLE tb_usuario (
    id int(11) NOT NULL AUTO_INCREMENT,
    email varchar(70) NOT NULL,
    hash varchar(77) NOT NULL,
    access int(11) DEFAULT 1,
    nome varchar(15) NOT NULL,
	UNIQUE KEY (hash),
	UNIQUE KEY (email),
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE tb_bebe;
CREATE TABLE tb_bebe (
    id int(11) NOT NULL AUTO_INCREMENT,
    id_user int(11) NOT NULL,
    nome varchar(50) NOT NULL,
    born date NOT NULL,
    sexo boolean DEFAULT 1,
    sel boolean default 1,
	FOREIGN KEY (id_user)
	REFERENCES tb_usuario (id),
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE tb_do;
CREATE TABLE tb_do (
    id_owner INT(11) NOT NULL,
    id_bebe INT(11) NOT NULL,
    id_modal INT(11) NOT NULL DEFAULT 1,
    dia TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    obs varchar(256) DEFAULT NULL,
    FOREIGN KEY (id_owner)
	REFERENCES tb_usuario (id),
    FOREIGN KEY (id_bebe)
	REFERENCES tb_bebe (id),
    PRIMARY KEY (id_owner , dia)
)  ENGINE=MYISAM AUTO_INCREMENT=0 DEFAULT CHARSET=UTF8;

ALTER TABLE tb_doit ADD COLUMN serie int(11) DEFAULT 3;
ALTER TABLE tb_doit ADD COLUMN lance int(11) DEFAULT 10;

DROP TABLE tb_modal;
CREATE TABLE tb_modal (
    id int(11) NOT NULL,
    id_user int(11) NOT NULL,
    nome VARCHAR(15) NOT NULL,
    getlance BOOLEAN DEFAULT 0,
    PRIMARY KEY (id,id_user)
)  ENGINE=MYISAM AUTO_INCREMENT=0 DEFAULT CHARSET=UTF8;

 DROP TABLE tb_my_modal;
CREATE TABLE tb_my_modal (
    id_user int(11) NOT NULL,
    id_modal int(11) NOT NULL,
    serie int(11) NOT NULL DEFAULT 3,
    lance int(11) NOT NULL DEFAULT 10,
    FOREIGN KEY (id_user) REFERENCES tb_usuario (id),
    FOREIGN KEY (id_modal) REFERENCES tb_modal (id),
    PRIMARY KEY (id_user, id_modal)
)  ENGINE=MYISAM AUTO_INCREMENT=0 DEFAULT CHARSET=UTF8;