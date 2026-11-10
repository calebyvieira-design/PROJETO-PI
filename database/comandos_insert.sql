insert into enderecos (estado, tipoEndereco, cep, logradouro, numero, bairro, cidade) values
('SP', 'Casa', '12345678', 'Rua Brasil', '1994', 'Jardim Paulista', 'São Paulo');

insert into contatos (telefonePrincipal, telefoneSecundario, email, aceitaNotificacao) values
('00123456789', '22987654321', 'rafael.zontarzb@gmail.com', "Sim");

insert into contratosassinaturas (dataAdesao, vencimentoFatura) values
('2020-11-10', '2027-12-30');

insert into clientes (
	nomeCompleto, tipoPessoa, cpfCnpj, rg, dataNascimento, dataCadastro, statusCliente, 
    enderecos_idendereco, contatos_idcontato, contratosassinaturas_idcontrato
) values
( 
	'Rafael Zonta', 'Física', '123.456.789-11', '123456789', '2007-12-12', '2020-11-09', 'Ativo',
	1, 1, 1
);

alter table planos
drop column contatos_idcontato;

alter table planos
add column contratosAssinaturas_idcontrato int;

alter table contatos
drop column aceitaNotificacao;

alter table contatos
add column aceitaNotificacao bool not null;

alter table planos
add constraint fk_planos_contratosAssinaturas
foreign key (contratosAssinaturas_idcontrato)
references contratosassinaturas(idcontrato);

update contatos set aceitaNotificacao = true where idcontato = 1;
update clientes set nomeCompleto = "Nicolas Rewell Alves", rg = 2983434 where idcliente = 2;

insert into planos (nome, velocidade, mensalidade, contratosAssinaturas_idcontrato) values
	("Plano Diamante", 700, 159.9, 1);

select * from enderecos;
select * from clientes;
select * from planos;
select * from contratosassinaturas;
select * from contatos;

delete from enderecos where idendereco = 2;
delete from contatos where idcontato = 2;
delete from contratosassinaturas where idcontrato = 2;



select LAST_INSERT_ID();

select clientes.idcliente, clientes.nomeCompleto, clientes.contratosAssinaturas_idcontrato, planos.nome, contratosassinaturas.vencimentoFatura
from clientes
join contratosassinaturas on (contratosassinaturas.idcontrato = clientes.contratosAssinaturas_idcontrato)
join planos on (planos.contratosAssinaturas_idcontrato = contratosassinaturas.idcontrato)
where clientes.idcliente = 4;

INSERT INTO enderecos (logradouro, numero, complemento, bairro, cidade, cep, estado, tipoEndereco) values
();




