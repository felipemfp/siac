﻿/*
This file is part of SIAC.

Copyright (C) 2016 Felipe Mateus Freire Pontes <felipemfpontes@gmail.com>
Copyright (C) 2016 Francisco Bento da Silva Júnior <francisco.bento.jr@hotmail.com>

SIAC is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details. 
*/
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;

namespace SIAC.Models
{
    public partial class AvalAuto
    {
        [NotMapped]
        public List<Disciplina> Disciplina => this.Avaliacao.AvaliacaoTema.Select(at => at.Tema.Disciplina).Distinct().ToList();

        private static Contexto contexto => Repositorio.GetInstance();

        public static void Inserir(AvalAuto AvalAuto)
        {
            contexto.AvalAuto.Add(AvalAuto);
            contexto.SaveChanges();
        }

        public static List<AvalAuto> ListarPorPessoa(int codPessoaFisica) => contexto.AvalAuto.Where(auto => auto.CodPessoaFisica == codPessoaFisica).OrderByDescending(auto => auto.Avaliacao.DtCadastro).ToList();

        public static AvalAuto ListarPorCodigoAvaliacao(string codigo) => Avaliacao.ListarPorCodigoAvaliacao(codigo)?.AvalAuto;

        public static List<AvalAuto> ListarNaoRealizadaPorPessoa(int codPessoaFisica)
        {
            List<AvalAuto> autoavaliacoes = contexto.AvalAuto.Where(auto => auto.CodPessoaFisica == codPessoaFisica).ToList();
            return autoavaliacoes.Where(a => a.Avaliacao.FlagPendente).ToList();
        }

        [NotMapped]
        public Dictionary<string, List<Questao>> DicionarioDisciplinaQuestao
        {
            get
            {
                Dictionary<string, List<Questao>> retorno = new Dictionary<string, List<Questao>>();

                int[] codDisciplinas = this.Disciplina.OrderBy(d => d.Descricao).Select(d => d.CodDisciplina).ToArray();

                foreach (var codDisciplina in codDisciplinas)
                {
                    List<Questao> questoes = this.Avaliacao.QuestaoTema
                        .Where(qt => qt.CodDisciplina == codDisciplina)
                        .OrderBy(qt => qt.Questao.CodTipoQuestao)
                        .ThenBy(qt => qt.CodQuestao)
                        .Select(qt => qt.Questao)
                        .ToList();

                    string disciplina = questoes.FirstOrDefault().Disciplina.Descricao;

                    retorno.Add(disciplina, questoes);
                }

                return retorno;
            }
        }
    }
}