
--adicionando valores as tabelas

create or replace PROCEDURE insert_datas_t_ecloc
IS
BEGIN

    INSERT INTO t_ecloc VALUES(1,'21/05/22', 'centro', 3, 1, 'Sao Paulo', 'SP', 5, 1);
    INSERT INTO t_ecloc VALUES(2,'21/05/22', 'centro', 3, 1, 'Sao Paulo', 'SP', 2, 2);
    INSERT INTO t_ecloc VALUES(3,'21/05/22', 'centro', 3, 1, 'Sao Paulo', 'SP', 3, 3);
    INSERT INTO t_ecloc VALUES(4,'21/05/22', 'rural', 3, 1, 'Boa Vista', 'SP', 4, 4);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN ROLLBACK;
END;

create or replace PROCEDURE insert_datas_t_ecvei
IS
BEGIN

    INSERT INTO t_ecvei VALUES(1,'gol','vw','hatch','IWQ133','vw',33,72);
    INSERT INTO t_ecvei VALUES(2,'fiat','vw','hatch','IWQ143','vw',33,74);
    INSERT INTO t_ecvei VALUES(3,'fusca','vw','hatch','IWQ153','vw',33,75);
    INSERT INTO t_ecvei VALUES(4,'bicicleta','vw','hatch','IWQ163','vw',33,76); 

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN ROLLBACK;
END;

create or replace PROCEDURE insert_datas_t_ecmap
IS
BEGIN
    INSERT INTO t_ecmap VALUES(5, 'Costa Verde', '21-05-2022','Groot');
    INSERT INTO t_ecmap VALUES(2, 'Porto Rico', '10-05-2022','Marvel');
    INSERT INTO t_ecmap VALUES(3, 'Santa Catarina', '19-05-2022','DC');
    INSERT INTO t_ecmap VALUES(4, 'São Paulo', '30-05-2022','WM');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN ROLLBACK;
END;

create or replace PROCEDURE insert_datas_t_ectemp
IS
BEGIN
    INSERT INTO t_ectemp VALUES(1, 30, '21/05/2022', 'ENSOLARADO', 1, 1);
    INSERT INTO t_ectemp VALUES(2, 29, '20/05/2022', 'CHUVOSO', 2, 2);
    INSERT INTO t_ectemp VALUES(3, 28, '21/04/2022', 'NUBLADO', 3, 3);
    INSERT INTO t_ectemp VALUES(4, 31, '21/03/2022', 'ENSOLARADO', 4, 4);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN ROLLBACK;
END;

EXECUTE insert_datas_t_ecloc;
EXECUTE insert_datas_t_ecvei;
EXECUTE insert_datas_t_ecmap;
EXECUTE insert_datas_t_ectemp;

SELECT * FROM t_ecvei;
SELECT * FROM t_ecmap;
SELECT * FROM t_ecloc;
SELECT * FROM t_ectemp;

Automação de rotinas 1 - Validação de níveis de temperado, baseado na regra de negocio do nosso projeto.

SET SERVEROUTPUT ON

CREATE OR REPLACE TRIGGER mud_temp
BEFORE INSERT OR UPDATE ON t_ectemp
FOR EACH ROW
    WHEN(OLD.valor_temp != NEW.valor_temp)
DECLARE
    dif_temp number;
BEGIN
    dif_temp := :NEW.valor_temp - :OLD.valor_temp;
    
    DBMS_OUTPUT.PUT_LINE('Temperatura Anterior: ' || :OLD.valor_temp ||'°');
    DBMS_OUTPUT.PUT_LINE('Temperatura Nova: ' || :NEW.valor_temp ||'°');
    DBMS_OUTPUT.PUT_LINE('Diferença temperatura: ' || dif_temp ||'°');
END;

--teste trigger

UPDATE T_ECTEMP SET valor_temp = 40
    WHERE id_tem = 4;
    ROLLBACK;

Automação de rotinas 2 - Insert Automático de dados nas tabelas


create or replace PROCEDURE insert_datas_t_ecloc
IS
BEGIN

    INSERT INTO t_ecloc VALUES(1,'21/05/22', 'centro', 3, 1, 'Sao Paulo', 'SP', 5, 1);
    INSERT INTO t_ecloc VALUES(2,'21/05/22', 'centro', 3, 1, 'Sao Paulo', 'SP', 2, 2);
    INSERT INTO t_ecloc VALUES(3,'21/05/22', 'centro', 3, 1, 'Sao Paulo', 'SP', 3, 3);
    INSERT INTO t_ecloc VALUES(4,'21/05/22', 'rural', 3, 1, 'Boa Vista', 'SP', 4, 4);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN ROLLBACK;
END;


Automação de rotinas 3 – Caso projeto aprovado, retorno de relatório geral.

Declare
      Cursor Cur_Cli Is
      Select nm_mapea, nm_fantasia
      From t_ecmap;
      Reg_Cli Cur_Cli%Rowtype;
Begin
      Open Cur_Cli;
      Loop
            Fetch Cur_Cli
            Into  Reg_Cli.nm_mapea, Reg_Cli.nm_fantasia;
            Exit When Cur_Cli%NotFound;
            Dbms_Output.Put_Line('Aprovação:' || Reg_Cli.nm_fantasia);
            Dbms_Output.Put_Line('Nome Mapeamento:' || Reg_Cli.nm_mapea);
      End Loop;
      Close Cur_Cli;
End;


Automação de rotinas 4 – Deleção automática baseado nas regras de negócios do nosso projeto.

CREATE OR REPLACE PROCEDURE del_user_atv (id_user IN NUMBER) IS
BEGIN
    delete from t_ecmap where cd_mapea = id_user;
END del_user_atv;

--teste deletar atividade usuario
 
EXECUTE del_user_atv(2);
    ROLLBACK;


RM 87188 – Diogo Reiznaudtt Poetsch
RM 86797 – Natanael Martins Felix da Silva

