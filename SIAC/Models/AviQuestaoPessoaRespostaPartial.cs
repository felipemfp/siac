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
using System;
using System.Collections.Generic;
using System.Linq;

namespace SIAC.Models
{
    public partial class AviQuestaoPessoaResposta
    {
        private static Contexto contexto => Repositorio.GetInstance();

        public static void InserirResposta(AviQuestao questao, PessoaFisica pessoa, int alternativa)
        {
            AviQuestaoPessoaResposta resposta = contexto.AviQuestaoPessoaResposta
                .Where(pr => pr.Ano == questao.Ano
                    && pr.Semestre == questao.Semestre
                    && pr.CodTipoAvaliacao == questao.CodTipoAvaliacao
                    && pr.NumIdentificador == questao.NumIdentificador
                    && pr.CodOrdem == questao.CodOrdem)
                .OrderByDescending(pr => pr.CodRespostaOrdem)
                .FirstOrDefault();

            int novaOrdemResposta = resposta != null ? resposta.CodRespostaOrdem + 1 : 1;

            AviQuestaoPessoaResposta novaResposta = new AviQuestaoPessoaResposta
            {
                AviQuestao = questao,
                PessoaFisica = pessoa
            };

            novaResposta.CodRespostaOrdem = novaOrdemResposta;
            novaResposta.RespAlternativa = alternativa;
            novaResposta.RespData = DateTime.Now;

            contexto.AviQuestaoPessoaResposta.Add(novaResposta);
            contexto.SaveChanges();
        }

        public static void InserirResposta(AviQuestao questao, PessoaFisica pessoa, string texto)
        {
            AviQuestaoPessoaResposta resposta = contexto.AviQuestaoPessoaResposta
                .Where(pr => pr.Ano == questao.Ano
                    && pr.Semestre == questao.Semestre
                    && pr.CodTipoAvaliacao == questao.CodTipoAvaliacao
                    && pr.NumIdentificador == questao.NumIdentificador
                    && pr.CodOrdem == questao.CodOrdem)
                .OrderByDescending(pr => pr.CodRespostaOrdem)
                .FirstOrDefault();

            int novaOrdemResposta = resposta != null ? resposta.CodRespostaOrdem + 1 : 1;

            AviQuestaoPessoaResposta novaResposta = new AviQuestaoPessoaResposta
            {
                AviQuestao = questao,
                PessoaFisica = pessoa
            };

            novaResposta.CodRespostaOrdem = novaOrdemResposta;
            novaResposta.RespDiscursiva = texto;
            novaResposta.RespData = DateTime.Now;

            contexto.AviQuestaoPessoaResposta.Add(novaResposta);
            contexto.SaveChanges();
        }

        public static void InserirResposta(AviQuestao questao, PessoaFisica pessoa, int alternativa, string texto)
        {
            AviQuestaoPessoaResposta resposta = contexto.AviQuestaoPessoaResposta
                .Where(pr => pr.Ano == questao.Ano
                    && pr.Semestre == questao.Semestre
                    && pr.CodTipoAvaliacao == questao.CodTipoAvaliacao
                    && pr.NumIdentificador == questao.NumIdentificador
                    && pr.CodOrdem == questao.CodOrdem)
                .OrderByDescending(pr => pr.CodRespostaOrdem)
                .FirstOrDefault();

            int novaOrdemResposta = resposta != null ? resposta.CodRespostaOrdem + 1 : 1;

            AviQuestaoPessoaResposta novaResposta = new AviQuestaoPessoaResposta
            {
                AviQuestao = questao,
                PessoaFisica = pessoa
            };

            novaResposta.CodRespostaOrdem = novaOrdemResposta;
            novaResposta.RespAlternativa = alternativa;
            novaResposta.RespDiscursiva = texto;
            novaResposta.RespData = DateTime.Now;

            contexto.AviQuestaoPessoaResposta.Add(novaResposta);
            contexto.SaveChanges();
        }

        public static List<AviQuestaoPessoaResposta> ObterRespostasPessoa(AvalAvi avi, PessoaFisica pessoa)
        {
            List<AviQuestaoPessoaResposta> respostas = contexto.AviQuestaoPessoaResposta
                .Where(pr => pr.Ano == avi.Ano
                    && pr.Semestre == avi.Semestre
                    && pr.CodTipoAvaliacao == avi.CodTipoAvaliacao
                    && pr.NumIdentificador == avi.NumIdentificador
                    && pr.CodPessoaFisica == pessoa.CodPessoa)
                .ToList();

            List<AviQuestaoPessoaResposta> retorno = new List<AviQuestaoPessoaResposta>();
            if (respostas.Count > 0)
            {
                int quantidadeQuestoes = respostas.Max(pr => pr.CodOrdem);
                for (int i = 1; i <= quantidadeQuestoes; i++)
                {
                    AviQuestaoPessoaResposta questao = respostas.Where(pr => pr.CodOrdem == i).OrderByDescending(pr => pr.CodRespostaOrdem).FirstOrDefault();
                    if (questao != null)
                        retorno.Add(questao);
                }
            }
            return retorno;
        }
    }
}