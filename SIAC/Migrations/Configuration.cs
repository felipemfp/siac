/*
This file is part of SIAC.

Copyright (C) 2016 Felipe Mateus Freire Pontes <felipemfpontes@gmail.com>
Copyright (C) 2016 Francisco Bento da Silva J�nior <francisco.bento.jr@hotmail.com>

SIAC is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details. 
*/
namespace SIAC.Migrations
{
    using Helpers;
    using Models;
    using System;
    using System.Data.Entity.Migrations;

    internal sealed class Configuration : DbMigrationsConfiguration<Contexto>
    {
        public Configuration()
        {
            AutomaticMigrationsEnabled = true;
        }

        protected override void Seed(Contexto context)
        {
            const string InstituicaoRazaoSocial = "Instituto Federal de Educa��o, Ci�ncia e Tecnologia do Rio Grande do Norte";
            const string InstituicaoNomeFantasia = "Insituto Federal do Rio Grande do Norte";
            const string InstituicaoSigla = "IFRN";
            const string InstituicaoCNPJ = "10877412001059";
            const string InstituicaoPortal = "http://portal.ifrn.edu.br";

            SemearEstruturas(context);
            SemearLocalidades(context);
            SemearParametros(context);

            if (!(context.Pessoa.Find(1)?.TipoPessoa == Pessoa.FISICA) && !(context.Pessoa.Find(2)?.TipoPessoa == Pessoa.JURIDICA))
            {
                context.Pessoa.AddOrUpdate(
                    p => p.CodPessoa,
                    new Pessoa
                    {
                        CodPessoa = 1,
                        TipoPessoa = Pessoa.FISICA
                    },
                    new Pessoa
                    {
                        CodPessoa = 2,
                        TipoPessoa = Pessoa.JURIDICA
                    }
                );
            }

            if (!(context.PessoaFisica.Find(1)?.Nome == "Superusu�rio"))
            {
                context.PessoaFisica.AddOrUpdate(
                    p => p.CodPessoa,
                    new PessoaFisica
                    {
                        CodPessoa = 1,
                        Nome = "Superusu�rio"
                    }
                );
            }

            context.PessoaFisica.Find(1).Ocupacao.Add(context.Ocupacao.Find(Ocupacao.SUPERUSUARIO));
            context.PessoaFisica.Find(1).Categoria.Add(context.Categoria.Find(Categoria.SUPERUSUARIO));

            if (!(context.PessoaJuridica.Find(2)?.Cnpj == InstituicaoCNPJ))
            {
                context.PessoaJuridica.AddOrUpdate(
                   p => p.CodPessoa,
                   new PessoaJuridica
                   {
                       CodPessoa = 2,
                       NomeFantasia = InstituicaoNomeFantasia,
                       RazaoSocial = InstituicaoRazaoSocial,
                       Cnpj = InstituicaoCNPJ,
                       Portal = InstituicaoPortal
                   }
               );
            }

            if (!(context.Instituicao.Find(1)?.Sigla == InstituicaoSigla))
            {
                context.Instituicao.AddOrUpdate(
                    i => i.CodInstituicao,
                    new Instituicao
                    {
                        CodInstituicao = 1,
                        CodPessoaJuridica = 2,
                        Sigla = InstituicaoSigla
                    }
                );
            }

            context.Usuario.AddOrUpdate(
                u => u.Matricula,
                new Usuario
                {
                    Matricula = "superusuario",
                    Senha = Helpers.Criptografia.RetornarHash("superusuario"),
                    CodPessoaFisica = 1,
                    CodCategoria = Categoria.SUPERUSUARIO,
                    DtCadastro = System.DateTime.Now
                }
            );
        }

        private void SemearEstruturas(Contexto context)
        {
            context.Categoria.AddOrUpdate(
                c => c.CodCategoria,
                new Categoria
                {
                    CodCategoria = Categoria.SUPERUSUARIO,
                    Descricao = "Superusu�rio"
                },
                new Categoria
                {
                    CodCategoria = Categoria.ALUNO,
                    Descricao = "Aluno"
                },
                new Categoria
                {
                    CodCategoria = Categoria.PROFESSOR,
                    Descricao = "Professor"
                },
                new Categoria
                {
                    CodCategoria = Categoria.COLABORADOR,
                    Descricao = "Colaborador"
                },
                new Categoria
                {
                    CodCategoria = Categoria.VISITANTE,
                    Descricao = "Visitante"
                }
            );

            context.Ocupacao.AddOrUpdate(
                o => o.CodOcupacao,
                new Ocupacao
                {
                    CodOcupacao = Ocupacao.SUPERUSUARIO,
                    Descricao = "Superusu�rio"
                },
                new Ocupacao
                {
                    CodOcupacao = Ocupacao.REITOR,
                    Descricao = "Reitor"
                },
                new Ocupacao
                {
                    CodOcupacao = Ocupacao.PRO_REITOR,
                    Descricao = "Pr�-Reitor"
                },
                new Ocupacao
                {
                    CodOcupacao = Ocupacao.DIRETOR_GERAL,
                    Descricao = "Diretor-Geral"
                },
                new Ocupacao
                {
                    CodOcupacao = Ocupacao.DIRETOR,
                    Descricao = "Diretor"
                },
                new Ocupacao
                {
                    CodOcupacao = Ocupacao.COORDENADOR,
                    Descricao = "Coordenador"
                },
                new Ocupacao
                {
                    CodOcupacao = Ocupacao.COORDENADOR_AVI,
                    Descricao = "Coordenador de Avalia��o Institucional"
                },
                new Ocupacao
                {
                    CodOcupacao = Ocupacao.COORDENADOR_SIMULADO,
                    Descricao = "Coordenador de Simulado"
                },
                new Ocupacao
                {
                    CodOcupacao = Ocupacao.COLABORADOR_SIMULADO,
                    Descricao = "Colaborador de Simulado"
                }
            );

            context.DiaSemana.AddOrUpdate(
                d => d.CodDia,
                new DiaSemana
                {
                    CodDia = 1,
                    Descricao = "Domingo"
                },
                new DiaSemana
                {
                    CodDia = 2,
                    Descricao = "Segunda-Feira"
                },
                new DiaSemana
                {
                    CodDia = 3,
                    Descricao = "Ter�a-Feira"
                },
                new DiaSemana
                {
                    CodDia = 4,
                    Descricao = "Quarta-Feira"
                },
                new DiaSemana
                {
                    CodDia = 5,
                    Descricao = "Quinta-Feira"
                },
                new DiaSemana
                {
                    CodDia = 6,
                    Descricao = "Sexta-Feira"
                },
                new DiaSemana
                {
                    CodDia = 7,
                    Descricao = "S�bado"
                }
            );

            context.NivelEnsino.AddOrUpdate(
                n => n.CodNivelEnsino,
                new NivelEnsino
                {
                    CodNivelEnsino = 1,
                    Descricao = "P�s-Doutorado",
                    Sigla = "PosDc"
                },
                new NivelEnsino
                {
                    CodNivelEnsino = 2,
                    Descricao = "Doutorado",
                    Sigla = "Doc"
                },
                new NivelEnsino
                {
                    CodNivelEnsino = 3,
                    Descricao = "Mestrado",
                    Sigla = "Mes"
                },
                new NivelEnsino
                {
                    CodNivelEnsino = 4,
                    Descricao = "Especialista",
                    Sigla = "Esp"
                },
                new NivelEnsino
                {
                    CodNivelEnsino = 5,
                    Descricao = "Gradua�ao",
                    Sigla = "Grad"
                },
                new NivelEnsino
                {
                    CodNivelEnsino = 6,
                    Descricao = "T�cnico",
                    Sigla = "Tec"
                }
            );

            context.Dificuldade.AddOrUpdate(
                d => d.CodDificuldade,
                new Dificuldade
                {
                    CodDificuldade = 1,
                    Descricao = "F�cil",
                    Comentario = "As quest�es desse grau devem exigir um conhecimento b�sico do assunto desejado, sem ter rela��o direta com outros assuntos."
                },
                new Dificuldade
                {
                    CodDificuldade = 2,
                    Descricao = "M�dio",
                    Comentario = "As quest�es desse grau devem exigir um conhecimento b�sico do assunto desejado, mas existindo a necessidade de alguns conhecimentos anteriores."
                },
                new Dificuldade
                {
                    CodDificuldade = 3,
                    Descricao = "Complicado",
                    Comentario = "As quest�es desse grau devem exigir um conhecimento mais avan�ado do assunto desejado, exigindo a necessidade de conhecimentos anteriores."
                },
                new Dificuldade
                {
                    CodDificuldade = 4,
                    Descricao = "Dif�cil",
                    Comentario = "As quest�es desse grau devem exigir um conhecimento avan�ado e que exijam racioc�nio l�gico do assunto desejado e que tamb�m exijam a necessidade de conhecimentos anteriores."
                },
                new Dificuldade
                {
                    CodDificuldade = 5,
                    Descricao = "Complexo",
                    Comentario = "As quest�es desse grau devem exigir um conhecimento avan�ado, racioc�nio l�gico do assunto desejado, e que tamb�m exijam a necessidade de conhecimentos anteriores com a mesma exig�ncia do assunto principal da quest�o."
                }
            );

            context.AviTipoPublico.AddOrUpdate(
                p => p.CodAviTipoPublico,
                new AviTipoPublico
                {
                    CodAviTipoPublico = AviTipoPublico.INSTITUICAO,
                    Descricao = "Institui��o"
                },
                new AviTipoPublico
                {
                    CodAviTipoPublico = AviTipoPublico.REITORIA,
                    Descricao = "Reitoria"
                },
                new AviTipoPublico
                {
                    CodAviTipoPublico = AviTipoPublico.PRO_REITORIA,
                    Descricao = "Pr�-Reitoria"
                },
                new AviTipoPublico
                {
                    CodAviTipoPublico = AviTipoPublico.CAMPUS,
                    Descricao = "Campus"
                },
                new AviTipoPublico
                {
                    CodAviTipoPublico = AviTipoPublico.DIRETORIA,
                    Descricao = "Diretoria"
                },
                new AviTipoPublico
                {
                    CodAviTipoPublico = AviTipoPublico.CURSO,
                    Descricao = "Curso"
                },
                new AviTipoPublico
                {
                    CodAviTipoPublico = AviTipoPublico.TURMA,
                    Descricao = "Turma"
                },
                new AviTipoPublico
                {
                    CodAviTipoPublico = AviTipoPublico.PESSOA,
                    Descricao = "Pessoa"
                }
            );

            context.Area.AddOrUpdate(
                a => a.CodArea,
                new Area
                {
                    CodArea = 1,
                    Descricao = "Ci�ncias Exatas e da Terra"
                },
                new Area
                {
                    CodArea = 2,
                    Descricao = "Ci�ncias Biol�gicas"
                },
                new Area
                {
                    CodArea = 3,
                    Descricao = "Engenharias"
                },
                new Area
                {
                    CodArea = 4,
                    Descricao = "Ci�ncias da Sa�de"
                },
                new Area
                {
                    CodArea = 5,
                    Descricao = "Ci�ncias Agr�rias"
                },
                new Area
                {
                    CodArea = 6,
                    Descricao = "Ci�ncias Sociais Aplicadas"
                },
                new Area
                {
                    CodArea = 7,
                    Descricao = "Ci�ncias Humanas"
                },
                new Area
                {
                    CodArea = 8,
                    Descricao = "Lingu�stica, Letras e Artes"
                }
            );

            context.Turno.AddOrUpdate(
                t => t.CodTurno,
                new Turno
                {
                    CodTurno = "M",
                    Descricao = "Matutino"
                },
                new Turno
                {
                    CodTurno = "V",
                    Descricao = "Vespertino"
                },
                new Turno
                {
                    CodTurno = "N",
                    Descricao = "Noturno"
                }
            );

            context.TipoQuestao.AddOrUpdate(
                t => t.CodTipoQuestao,
                new TipoQuestao
                {
                    CodTipoQuestao = 1,
                    Descricao = "Objetiva",
                    Sigla = "OBJ"
                },
                new TipoQuestao
                {
                    CodTipoQuestao = 2,
                    Descricao = "Discursiva",
                    Sigla = "DISC"
                }
            );

            context.TipoContato.AddOrUpdate(
                t => t.CodTipoContato,
                new TipoContato
                {
                    CodTipoContato = 1,
                    Descricao = "Pessoal"
                },
                new TipoContato
                {
                    CodTipoContato = 2,
                    Descricao = "Institucional"
                },
                new TipoContato
                {
                    CodTipoContato = 3,
                    Descricao = "Profissional"
                }
            );

            context.TipoAvaliacao.AddOrUpdate(
                t => t.CodTipoAvaliacao,
                new TipoAvaliacao
                {
                    CodTipoAvaliacao = TipoAvaliacao.AUTOAVALIACAO,
                    Descricao = "Autoavalia��o",
                    Sigla = "AUTO"
                },
                new TipoAvaliacao
                {
                    CodTipoAvaliacao = TipoAvaliacao.ACADEMICA,
                    Descricao = "Avalia��o Acad�mica",
                    Sigla = "ACAD"
                },
                new TipoAvaliacao
                {
                    CodTipoAvaliacao = TipoAvaliacao.CERTIFICACAO,
                    Descricao = "Avalia��o de Certifica��o",
                    Sigla = "CERT"
                },
                new TipoAvaliacao
                {
                    CodTipoAvaliacao = TipoAvaliacao.REPOSICAO,
                    Descricao = "Avalia��o de Reposi��o",
                    Sigla = "REPO"
                },
                new TipoAvaliacao
                {
                    CodTipoAvaliacao = TipoAvaliacao.AVI,
                    Descricao = "Avalia��o Institucional",
                    Sigla = "AVI"
                }
            );

            context.TipoAnexo.AddOrUpdate(
                t => t.CodTipoAnexo,
                new TipoAnexo
                {
                    CodTipoAnexo = TipoAnexo.IMAGEM,
                    Descricao = "Imagem"
                },
                new TipoAnexo
                {
                    CodTipoAnexo = TipoAnexo.CODIGO,
                    Descricao = "C�digo"
                },
                new TipoAnexo
                {
                    CodTipoAnexo = TipoAnexo.TEXTO,
                    Descricao = "Texto"
                }
            );
        }

        private void SemearLocalidades(Contexto context)
        {
            var estados = (Configuracoes.Recuperar("ESTADOS") as string).ToUpper();
            var nordeste = Convert.ToBoolean(Configuracoes.Recuperar("ESTADOS_NORDESTE"));
            var norte = Convert.ToBoolean(Configuracoes.Recuperar("ESTADOS_NORTE"));
            var sul = Convert.ToBoolean(Configuracoes.Recuperar("ESTADOS_SUL"));
            var sudeste = Convert.ToBoolean(Configuracoes.Recuperar("ESTADOS_SUDESTE"));
            var centrooeste = Convert.ToBoolean(Configuracoes.Recuperar("ESTADOS_CENTROOESTE"));

            context.Pais.AddOrUpdate(
                p => p.CodPais,
                new Pais { CodPais = 1, Descricao = "Brasil", Sigla = "BRA" }
            );

            #region Nordeste

            if (nordeste || estados.Contains("AL"))
            {
                Alagoas.Semear(context);
            }
            if (nordeste || estados.Contains("BA"))
            {
                Bahia.Semear(context);
            }
            if (nordeste || estados.Contains("CE"))
            {
                Ceara.Semear(context);
            }
            if (nordeste || estados.Contains("MA"))
            {
                Maranhao.Semear(context);
            }
            if (nordeste || estados.Contains("PB"))
            {
                Paraiba.Semear(context);
            }
            if (nordeste || estados.Contains("PE"))
            {
                Pernambuco.Semear(context);
            }
            if (nordeste || estados.Contains("PI"))
            {
                Piaui.Semear(context);
            }
            if (nordeste || estados.Contains("RN"))
            {
                RioGrandeDoNorte.Semear(context);
            }
            if (nordeste || estados.Contains("SE"))
            {
                Sergipe.Semear(context);
            }

            #endregion Nordeste

            #region Sudeste

            if (sudeste || estados.Contains("MG"))
            {
                MinasGerais.Semear(context);
            }
            if (sudeste || estados.Contains("ES"))
            {
                EspiritoSanto.Semear(context);
            }
            if (sudeste || estados.Contains("RJ"))
            {
                RioDeJaneiro.Semear(context);
            }
            if (sudeste || estados.Contains("SP"))
            {
                SaoPaulo.Semear(context);
            }

            #endregion Sudeste

            #region CentroOeste

            if (centrooeste || estados.Contains("GO"))
            {
                Goias.Semear(context);
            }
            if (centrooeste || estados.Contains("MT"))
            {
                MatoGrosso.Semear(context);
            }
            if (centrooeste || estados.Contains("MS"))
            {
                MatoGrossoDoSul.Semear(context);
            }

            #endregion CentroOeste

            #region Norte

            if (norte || estados.Contains("AC"))
            {
                Acre.Semear(context);
            }
            if (norte || estados.Contains("AP"))
            {
                Amapa.Semear(context);
            }
            if (norte || estados.Contains("AM"))
            {
                Amazonas.Semear(context);
            }
            if (norte || estados.Contains("PA"))
            {
                Para.Semear(context);
            }
            if (norte || estados.Contains("RO"))
            {
                Rondonia.Semear(context);
            }
            if (norte || estados.Contains("RR"))
            {
                Roraima.Semear(context);
            }
            if (norte || estados.Contains("TO"))
            {
                Tocantins.Semear(context);
            }

            #endregion Norte

            #region Sul

            if (sul || estados.Contains("RS"))
            {
                RioGrandeDoSul.Semear(context);
            }
            if (sul || estados.Contains("PR"))
            {
                Parana.Semear(context);
            }
            if (sul || estados.Contains("SC"))
            {
                SantaCatarina.Semear(context);
            }

            #endregion Sul

            if (estados.Contains("DF"))
            {
                DestritoFederal.Semear(context);
            }
        }

        private void SemearParametros(Contexto context)
        {
            if (context.Parametro.Find(1) == null)
            {
                context.Parametro.AddOrUpdate(
                    p => p.CodParametro,
                    new Parametro
                    {
                        CodParametro = 1,
                        PeriodoLetivoAnoAtual = System.DateTime.Today.Year,
                        PeriodoLetivoSemestreAtual = System.DateTime.Today.Month <= 6 ? 1 : 2,
                        QteSemestres = 2,
                        TempoInatividade = 15, // em dias
                        NumeracaoQuestao = (int)Parametro.NumeracaoPadrao.INDO_ARABICO,
                        NumeracaoAlternativa = (int)Parametro.NumeracaoPadrao.CAIXA_BAIXA,
                        ValorNotaMedia = 6,
                        TermoResponsabilidade = "Termo de Responsabilidade.\nN�o esque�a de atualizar.",
                        NotaUsoAcademica = "Nota de Uso para Avalia��o Acad�mica.\nN�o esque�a de atualizar.",
                        NotaUsoReposicao = "Nota de Uso para Avalia��o de Reposi��o.\nN�o esque�a de atualizar.",
                        NotaUsoCertificacao = "Nota de Uso para Avalia��o de Certifica��o.\nN�o esque�a de atualizar.",
                        NotaUsoInstitucional = "Nota de Uso para Avalia��o Institucional.\nN�o esque�a de atualizar.",
                        NotaUsoSimulado = "Nota de Uso para Simulado.\nN�o esque�a de atualizar.",
                        CoordenadorAVI = Newtonsoft.Json.JsonConvert.SerializeObject(new int[] {
                        Ocupacao.SUPERUSUARIO,
                        Ocupacao.REITOR,
                        Ocupacao.PRO_REITOR,
                        Ocupacao.DIRETOR_GERAL,
                        Ocupacao.DIRETOR
                        }),
                        SmtpEnderecoHost = "nao.esqueca.de.atualizar", // ex.: smpt.live.com
                        SmtpFlagSSL = false,
                        SmtpPorta = 25,
                        SmtpUsuario = Helpers.Criptografia.Base64Encode("usuario"),
                        SmtpSenha = Helpers.Criptografia.Base64Encode("senha")
                    }
                );
            }
        }
    }
}