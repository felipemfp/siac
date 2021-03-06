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
using SIAC.Helpers;
using SIAC.Models;
using SIAC.ViewModels;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web.Mvc;

namespace SIAC.Controllers
{
    [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.ALUNO, Categoria.PROFESSOR })]
    public class AcademicaController : Controller
    {
        public List<AvalAcademica> Academicas
        {
            get
            {
                if (Sessao.UsuarioCategoriaCodigo == Categoria.PROFESSOR)
                {
                    int codProfessor = Professor.ListarPorMatricula(Sessao.UsuarioMatricula).CodProfessor;
                    return AvalAcademica.ListarPorProfessor(codProfessor);
                }
                else
                {
                    int codAluno = Aluno.ListarPorMatricula(Sessao.UsuarioMatricula).CodAluno;
                    return AvalAcademica.ListarPorAluno(codAluno);
                }
            }
        }

        // POST: historico/academica/listar
        [HttpPost]
        public ActionResult Listar(int? pagina, string pesquisa, string ordenar, string categoria, string disciplina)
        {
            int quantidade = 12;
            List<AvalAcademica> academicas = Academicas;

            pagina = pagina ?? 1;
            if (!String.IsNullOrWhiteSpace(pesquisa))
            {
                academicas = academicas.Where(a => a.Avaliacao.CodAvaliacao.ToLower().Contains(pesquisa.ToLower())).ToList();
            }

            if (!String.IsNullOrWhiteSpace(disciplina))
            {
                academicas = academicas.Where(a => a.CodDisciplina == int.Parse(disciplina)).ToList();
            }

            switch (categoria)
            {
                case "agendada":
                    academicas = academicas.Where(a => a.Avaliacao.FlagAgendada).ToList();
                    break;

                case "realizada":
                    academicas = academicas.Where(a => a.Avaliacao.FlagRealizada).ToList();
                    break;

                case "arquivo":
                    academicas = academicas.Where(a => a.Avaliacao.FlagArquivo).ToList();
                    break;
            }

            switch (ordenar)
            {
                case "data_desc":
                    academicas = academicas.OrderByDescending(a => a.Avaliacao.DtCadastro).ToList();
                    break;

                case "data":
                    academicas = academicas.OrderBy(a => a.Avaliacao.DtCadastro).ToList();
                    break;

                default:
                    academicas = academicas.OrderByDescending(a => a.Avaliacao.DtCadastro).ToList();
                    break;
            }

            return PartialView("_ListaAcademica", academicas.Skip((quantidade * pagina.Value) - quantidade).Take(quantidade).ToList());
        }

        // GET: historico/avaliacao/academica
        public ActionResult Index()
        {
            if (Request.Url.ToString().ToLower().Contains("principal"))
            {
                return Redirect("~/historico/avaliacao/academica");
            }

            var model = new AvaliacaoIndexViewModel();
            model.Disciplinas = Academicas.Select(a => a.Disciplina).Distinct().ToList();
            return View(model);
        }

        // GET: principal/avaliacao/academica/gerar
        [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.PROFESSOR })]
        public ActionResult Gerar()
        {
            var model = new AvaliacaoGerarViewModel();
            model.Disciplinas = Disciplina.ListarPorProfessor(Helpers.Sessao.UsuarioMatricula);
            model.Dificuldades = Dificuldade.ListarOrdenadamente();
            model.Termo = Parametro.Obter().NotaUsoAcademica;

            return View(model);
        }

        // POST: principal/avaliacao/academica/confirmar
        [HttpPost]
        [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.PROFESSOR })]
        public ActionResult Confirmar(FormCollection formCollection)
        {
            if (Sessao.UsuarioCategoriaCodigo != Categoria.PROFESSOR)
            {
                if (Session["UrlReferrer"] != null)
                {
                    return Redirect(Session["UrlReferrer"].ToString());
                }
                else return RedirectToAction("Index", "Principal");
            }
            var acad = new AvalAcademica();
            if (formCollection.HasKeys())
            {
                DateTime hoje = DateTime.Now;

                /* Chave */
                acad.Avaliacao = new Avaliacao();
                acad.Avaliacao.TipoAvaliacao = TipoAvaliacao.ListarPorCodigo(TipoAvaliacao.ACADEMICA);
                acad.Avaliacao.Ano = hoje.Year;
                acad.Avaliacao.Semestre = hoje.SemestreAtual();
                acad.Avaliacao.NumIdentificador = Avaliacao.ObterNumIdentificador(TipoAvaliacao.ACADEMICA);
                acad.Avaliacao.DtCadastro = hoje;

                /* Professor */
                string matricula = Helpers.Sessao.UsuarioMatricula;
                acad.Professor = Professor.ListarPorMatricula(matricula);

                /* Dados */
                int codDisciplina = int.Parse(formCollection["ddlDisciplina"]);

                acad.CodDisciplina = codDisciplina;

                /* Dificuldade */
                int codDificuldade = int.Parse(formCollection["ddlDificuldade"]);

                /* Quantidade */
                int quantidadeObjetiva = 0;
                int quantidadeDiscursiva = 0;

                if (formCollection["ddlTipo"] == "3")
                {
                    int.TryParse(formCollection["txtQteObjetiva"], out quantidadeObjetiva);
                    int.TryParse(formCollection["txtQteDiscursiva"], out quantidadeDiscursiva);
                }
                else if (formCollection["ddlTipo"] == "2")
                {
                    int.TryParse(formCollection["txtQteDiscursiva"], out quantidadeDiscursiva);
                }
                else if (formCollection["ddlTipo"] == "1")
                {
                    int.TryParse(formCollection["txtQteObjetiva"], out quantidadeObjetiva);
                }

                /* Temas */
                string[] temaCodigos = formCollection["ddlTemas"].Split(',');

                /* Questões */
                List<QuestaoTema> lstQuestoes = new List<QuestaoTema>();

                if (quantidadeObjetiva > 0)
                {
                    lstQuestoes.AddRange(Questao.ListarPorDisciplina(codDisciplina, temaCodigos, codDificuldade, TipoQuestao.OBJETIVA, quantidadeObjetiva));
                }
                if (quantidadeDiscursiva > 0)
                {
                    lstQuestoes.AddRange(Questao.ListarPorDisciplina(codDisciplina, temaCodigos, codDificuldade, TipoQuestao.DISCURSIVA, quantidadeDiscursiva));
                }

                foreach (var temaCodigo in temaCodigos)
                {
                    var avalTema = new AvaliacaoTema();
                    avalTema.Tema = Tema.ListarPorCodigo(codDisciplina, int.Parse(temaCodigo));
                    foreach (var questaoTema in lstQuestoes.Where(q => q.CodTema == int.Parse(temaCodigo)))
                    {
                        var avalTemaQuestao = new AvalTemaQuestao();
                        avalTemaQuestao.QuestaoTema = questaoTema;
                        avalTema.AvalTemaQuestao.Add(avalTemaQuestao);
                    }
                    acad.Avaliacao.AvaliacaoTema.Add(avalTema);
                }

                AvalAcademica.Inserir(acad);
                Lembrete.AdicionarNotificacao($"Avaliação Acadêmica {acad.Avaliacao.CodAvaliacao} gerada com sucesso.", Lembrete.POSITIVO);
                if (quantidadeObjetiva + quantidadeDiscursiva > acad.Avaliacao.Questao.Count)
                {
                    Lembrete.AdicionarNotificacao("Avaliação Acadêmica gerada com quantidade de questões inferior ao requisitado", Lembrete.NEGATIVO, 0);
                }
            }

            return View(acad);
        }

        // GET: principal/avaliacao/academica/agendar/ACAD2015100002
        [HttpGet]
        [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.PROFESSOR })]
        public ActionResult Agendar(string codigo)
        {
            if (String.IsNullOrWhiteSpace(codigo) || Sistema.AvaliacaoUsuario.ContainsKey(codigo))
            {
                return RedirectToAction("Index");
            }
            AvalAcademica acad = AvalAcademica.ListarPorCodigoAvaliacao(codigo);

            string matricula = Helpers.Sessao.UsuarioMatricula;
            Professor professor = Professor.ListarPorMatricula(matricula);
            if (acad.CodProfessor == professor.CodProfessor)
            {
                var model = new AvaliacaoAgendarViewModel();

                model.Avaliacao = acad.Avaliacao;
                model.Turmas = professor.TurmaDiscProfHorario.Select(d => d.Turma).Distinct().OrderBy(t => t.Curso.Descricao).ToList();
                model.Salas = Sala.ListarOrdenadamente();

                return View(model);
            }
            return RedirectToAction("Index");
        }

        // POST: principal/avaliacao/academica/agendar/ACAD2015100002
        [HttpPost]
        [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.PROFESSOR })]
        public ActionResult Agendar(string codigo, FormCollection form)
        {
            if (Sessao.UsuarioCategoriaCodigo != Categoria.PROFESSOR)
            {
                if (Session["UrlReferrer"] != null)
                {
                    return Redirect(Session["UrlReferrer"].ToString());
                }
                else return RedirectToAction("Index", "Principal");
            }
            string codTurma = form["ddlTurma"];
            string strCodSala = form["ddlSala"];
            string data = form["txtData"];
            string horaInicio = form["txtHoraInicio"];
            string horaTermino = form["txtHoraTermino"];
            if (!StringExt.IsNullOrWhiteSpace(codTurma, strCodSala, data, horaInicio, horaTermino))
            {
                AvalAcademica acad = AvalAcademica.ListarPorCodigoAvaliacao(codigo);

                string matricula = Sessao.UsuarioMatricula;
                Professor professor = Professor.ListarPorMatricula(matricula);

                if (acad.CodProfessor == professor.CodProfessor)
                {
                    // Turma
                    Turma turma = Turma.ListarPorCodigo(codTurma);
                    if (turma != null)
                    {
                        acad.Turma = turma;
                    }

                    // Sala
                    int codSala;
                    int.TryParse(strCodSala, out codSala);
                    Sala sala = Sala.ListarPorCodigo(codSala);
                    if (sala != null)
                    {
                        acad.Sala = sala;
                    }

                    // Data de Aplicacao
                    DateTime dtAplicacao = DateTime.Parse(data + " " + horaInicio, new CultureInfo("pt-BR"));
                    DateTime dtAplicacaoTermino = DateTime.Parse(data + " " + horaTermino, new CultureInfo("pt-BR"));

                    if (dtAplicacao.IsFuture() && dtAplicacaoTermino.IsFuture() && dtAplicacaoTermino > dtAplicacao)
                    {
                        acad.Avaliacao.DtAplicacao = dtAplicacao;
                        acad.Avaliacao.Duracao = Convert.ToInt32((dtAplicacaoTermino - acad.Avaliacao.DtAplicacao.Value).TotalMinutes);
                    }

                    acad.Avaliacao.FlagLiberada = false;

                    Repositorio.Commit();
                }
            }

            return RedirectToAction("Agendada", new { codigo = codigo });
        }

        // GET: historico/avaliacao/academica/detalhe/ACAD201520001
        public ActionResult Detalhe(string codigo)
        {
            if (!String.IsNullOrWhiteSpace(codigo))
            {
                AvalAcademica acad = AvalAcademica.ListarPorCodigoAvaliacao(codigo);
                if (acad != null)
                {
                    return View(acad);
                }
            }

            return RedirectToAction("Index");
        }

        // GET: principal/avaliacao/academica/configurar/ACAD201520001
        [HttpGet]
        [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.PROFESSOR })]
        public ActionResult Configurar(string codigo)
        {
            TempData[$"listaQuestoesAntigas{codigo.ToUpper()}"] = new List<AvalTemaQuestao>();
            TempData[$"listaQuestoesNovas{codigo.ToUpper()}"] = new List<AvalTemaQuestao>();
            TempData[$"listaQuestoesPossiveisObj{codigo.ToUpper()}"] = new List<QuestaoTema>();
            TempData[$"listaQuestoesPossiveisDisc{codigo.ToUpper()}"] = new List<QuestaoTema>();
            TempData[$"listaQuestoesIndices{codigo.ToUpper()}"] = new List<int>();
            TempData[$"listaQuestoesRecentes{codigo.ToUpper()}"] = new List<int>();

            if (!String.IsNullOrWhiteSpace(codigo) && !Sistema.AvaliacaoUsuario.ContainsKey(codigo))
            {
                AvalAcademica acad = AvalAcademica.ListarPorCodigoAvaliacao(codigo);
                if (acad != null && acad.Avaliacao.AvalPessoaResultado.Count == 0)
                {
                    string matricula = Helpers.Sessao.UsuarioMatricula;
                    Professor professor = Professor.ListarPorMatricula(matricula);
                    if (professor != null)
                    {
                        if (professor.CodProfessor == acad.CodProfessor)
                        {
                            return View(acad);
                        }
                    }
                }
            }
            return RedirectToAction("Index");
        }

        // GET: principal/avaliacao/academica/imprimir/ACAD201520001
        [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.PROFESSOR })]
        public ActionResult Imprimir(string codigo)
        {
            if (!String.IsNullOrWhiteSpace(codigo) && !Sistema.AvaliacaoUsuario.ContainsKey(codigo))
            {
                AvalAcademica acad = AvalAcademica.ListarPorCodigoAvaliacao(codigo);
                if (acad != null)
                {
                    string matricula = Helpers.Sessao.UsuarioMatricula;
                    Professor professor = Professor.ListarPorMatricula(matricula);
                    if (professor.CodProfessor == acad.CodProfessor)
                    {
                        return View(acad);
                    }
                }
            }
            return RedirectToAction("Index");
        }

        // GET: historico/avaliacao/academica/agendada/ACAD201520001
        public ActionResult Agendada(string codigo)
        {
            if (!String.IsNullOrWhiteSpace(codigo))
            {
                Usuario usuario = Usuario.ListarPorMatricula(Helpers.Sessao.UsuarioMatricula);
                AvalAcademica acad = AvalAcademica.ListarAgendadaPorUsuario(usuario).FirstOrDefault(a => a.Avaliacao.CodAvaliacao.ToLower() == codigo.ToLower());
                if (acad != null)
                {
                    return View(acad);
                }
            }
            return RedirectToAction("Detalhe", new { codigo = codigo });
        }

        // POST: principal/avaliacao/academica/trocar/ACAD201520001
        [HttpPost]
        [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.PROFESSOR })]
        public ActionResult TrocarQuestao(string codigoAvaliacao, int tipo, int indice, int codQuestao)
        {
            List<AvalTemaQuestao> antigas = (List<AvalTemaQuestao>)TempData[$"listaQuestoesAntigas{codigoAvaliacao.ToUpper()}"];
            List<AvalTemaQuestao> novas = (List<AvalTemaQuestao>)TempData[$"listaQuestoesNovas{codigoAvaliacao.ToUpper()}"];
            List<QuestaoTema> questoesTrocaObjetiva = (List<QuestaoTema>)TempData[$"listaQuestoesPossiveisObj{codigoAvaliacao.ToUpper()}"];
            List<QuestaoTema> questoesTrocaDiscursiva = (List<QuestaoTema>)TempData[$"listaQuestoesPossiveisDisc{codigoAvaliacao.ToUpper()}"];
            List<int> indices = (List<int>)TempData[$"listaQuestoesIndices{codigoAvaliacao.ToUpper()}"];
            List<int> recentes = (List<int>)TempData[$"listaQuestoesRecentes{codigoAvaliacao.ToUpper()}"];

            TempData.Keep();

            if (!String.IsNullOrWhiteSpace(codigoAvaliacao))
            {
                AvalAcademica acad = AvalAcademica.ListarPorCodigoAvaliacao(codigoAvaliacao);
                if (acad != null)
                {
                    List<QuestaoTema> avalQuestTema = acad.Avaliacao.QuestaoTema;

                    QuestaoTema questao = null;

                    if (tipo == TipoQuestao.OBJETIVA)
                    {
                        if (questoesTrocaObjetiva.Count <= 0)
                        {
                            TempData[$"listaQuestoesPossiveisObj{codigoAvaliacao.ToUpper()}"] = Questao.ObterNovasQuestoes(avalQuestTema, tipo);
                            questoesTrocaObjetiva = (List<QuestaoTema>)TempData[$"listaQuestoesPossiveisObj{codigoAvaliacao.ToUpper()}"];
                        }

                        int random = Sistema.Random.Next(0, questoesTrocaObjetiva.Count);
                        questao = questoesTrocaObjetiva.ElementAtOrDefault(random);
                    }
                    else if (tipo == TipoQuestao.DISCURSIVA)
                    {
                        if (questoesTrocaDiscursiva.Count <= 0)
                        {
                            TempData[$"listaQuestoesPossiveisDisc{codigoAvaliacao.ToUpper()}"] = Questao.ObterNovasQuestoes(avalQuestTema, tipo);
                            questoesTrocaDiscursiva = (List<QuestaoTema>)TempData[$"listaQuestoesPossiveisDisc{codigoAvaliacao.ToUpper()}"];
                        }

                        int random = Sistema.Random.Next(0, questoesTrocaDiscursiva.Count);
                        questao = questoesTrocaDiscursiva.ElementAtOrDefault(random);
                    }

                    if (questao != null)
                    {
                        if (!indices.Contains(indice))
                        {
                            AvalTemaQuestao aqtAntiga =
                                (from atq in Repositorio.GetInstance().AvalTemaQuestao
                                 where atq.Ano == acad.Ano
                                 && atq.Semestre == acad.Semestre
                                 && atq.CodTipoAvaliacao == acad.CodTipoAvaliacao
                                 && atq.NumIdentificador == acad.NumIdentificador
                                 && atq.CodQuestao == codQuestao
                                 select atq).FirstOrDefault();
                            antigas.Add(aqtAntiga);
                            indices.Add(indice);
                        }

                        int index = indices.IndexOf(indice);

                        var atqNova = new AvalTemaQuestao();
                        atqNova.Ano = acad.Avaliacao.Ano;
                        atqNova.Semestre = acad.Avaliacao.Semestre;
                        atqNova.CodTipoAvaliacao = acad.Avaliacao.CodTipoAvaliacao;
                        atqNova.NumIdentificador = acad.Avaliacao.NumIdentificador;
                        atqNova.QuestaoTema = questao;

                        if (novas.Count > index)
                        {
                            novas.RemoveAt(index);
                        }
                        if (recentes.Count > index)
                        {
                            recentes.RemoveAt(index);
                        }

                        novas.Insert(index, atqNova);
                        recentes.Insert(index, codQuestao);

                        ViewData["Index"] = indice;
                        return PartialView("_QuestaoConfigurar", questao.Questao);
                    }
                }
            }

            return Json(String.Empty);
        }

        // POST: principal/avaliacao/academica/salvar/ACAD201520001
        [HttpPost]
        [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.PROFESSOR })]
        public ActionResult Salvar(string codigo)
        {
            List<AvalTemaQuestao> antigas = (List<AvalTemaQuestao>)TempData[$"listaQuestoesAntigas{codigo.ToUpper()}"];
            List<AvalTemaQuestao> novas = (List<AvalTemaQuestao>)TempData[$"listaQuestoesNovas{codigo.ToUpper()}"];

            if (antigas.Count != 0 && novas.Count != 0)
            {
                Contexto contexto = Repositorio.GetInstance();
                for (int i = 0; i < antigas.Count && i < novas.Count; i++)
                {
                    contexto.AvalTemaQuestao.Remove(antigas.ElementAtOrDefault(i));
                    contexto.AvalTemaQuestao.Add(novas.ElementAtOrDefault(i));
                }
                contexto.SaveChanges();
            }
            TempData.Clear();

            return RedirectToAction("Detalhe", new { codigo = codigo });
        }

        // POST: principal/avaliacao/academica/desfazer/ACAD201520001
        [HttpPost]
        [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.PROFESSOR })]
        public ActionResult Desfazer(string codigoAvaliacao, int tipoQuestao, int indice, int codQuestao)
        {
            List<AvalTemaQuestao> antigas = (List<AvalTemaQuestao>)TempData[$"listaQuestoesAntigas{codigoAvaliacao.ToUpper()}"];
            List<AvalTemaQuestao> novas = (List<AvalTemaQuestao>)TempData[$"listaQuestoesNovas{codigoAvaliacao.ToUpper()}"];
            List<QuestaoTema> questoesTrocaObj = (List<QuestaoTema>)TempData[$"listaQuestoesPossiveisObj{codigoAvaliacao.ToUpper()}"];
            List<QuestaoTema> questoesTrocaDisc = (List<QuestaoTema>)TempData[$"listaQuestoesPossiveisDisc{codigoAvaliacao.ToUpper()}"];
            List<int> indices = (List<int>)TempData[$"listaQuestoesIndices{codigoAvaliacao.ToUpper()}"];
            List<int> recentes = (List<int>)TempData[$"listaQuestoesRecentes{codigoAvaliacao.ToUpper()}"];

            TempData.Keep();

            if (!String.IsNullOrWhiteSpace(codigoAvaliacao))
            {
                int codQuestaoRecente = recentes[indices.IndexOf(indice)];

                QuestaoTema questao = null;

                if (tipoQuestao == TipoQuestao.OBJETIVA)
                {
                    questao = questoesTrocaObj.FirstOrDefault(qt => qt.CodQuestao == codQuestaoRecente);
                    if (questao == null)
                    {
                        questao = antigas[indices.IndexOf(indice)].QuestaoTema;
                    }
                }
                else if (tipoQuestao == TipoQuestao.DISCURSIVA)
                {
                    questao = questoesTrocaDisc.FirstOrDefault(qt => qt.CodQuestao == codQuestaoRecente);
                    if (questao == null)
                    {
                        questao = antigas[indices.IndexOf(indice)].QuestaoTema;
                    }
                }

                if (questao != null)
                {
                    novas[indices.IndexOf(indice)].QuestaoTema = questao;

                    ViewData["Index"] = indice;
                    return PartialView("_QuestaoConfigurar", questao.Questao);
                }
            }

            return Json(String.Empty);
        }

        // POST: contagemregressiva
        [HttpPost]
        public ActionResult ContagemRegressiva(string codAvaliacao)
        {
            AvalAcademica avalAcad = AvalAcademica.ListarPorCodigoAvaliacao(codAvaliacao);
            string tempo = avalAcad.Avaliacao.DtAplicacao.Value.ToLeftTimeString();
            int quantidadeMilissegundo = 0;
            bool flagLiberada = avalAcad.Avaliacao.FlagLiberada && avalAcad.Avaliacao.DtTermino > DateTime.Now;
            if (tempo != "Agora")
            {
                char tipo = tempo[(tempo.IndexOf(' ')) + 1];
                switch (tipo)
                {
                    case 'd':
                        quantidadeMilissegundo = 0;
                        break;

                    case 'h':
                        quantidadeMilissegundo = 1 * 60 * 60 * 1000;
                        break;

                    case 'm':
                        quantidadeMilissegundo = 1 * 60 * 1000;
                        break;

                    case 's':
                        quantidadeMilissegundo = 1 * 1000;
                        break;

                    default:
                        break;
                }
            }
            return Json(new { Tempo = tempo, Intervalo = quantidadeMilissegundo, FlagLiberada = flagLiberada });
        }

        // POST: principal/avaliacao/academica/liberar/ACAD201520001
        [HttpPost]
        [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.PROFESSOR })]
        public ActionResult AlternarLiberar(string codAvaliacao)
        {
            if (!String.IsNullOrWhiteSpace(codAvaliacao))
            {
                return Json(Avaliacao.AlternarFlagLiberada(codAvaliacao));
            }
            return Json(false);
        }

        // GET: principal/avaliacao/academica/acompanhar/ACAD201520007
        [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.PROFESSOR })]
        public ActionResult Acompanhar(string codigo)
        {
            if (!String.IsNullOrWhiteSpace(codigo))
            {
                if (Sessao.UsuarioCategoriaCodigo == Categoria.PROFESSOR)
                {
                    AvalAcademica acad = AvalAcademica.ListarPorCodigoAvaliacao(codigo);
                    if (acad != null && acad.Avaliacao.FlagAgendada && acad.Avaliacao.FlagAgora)
                    {
                        return View(acad);
                    }
                }
            }
            return RedirectToAction("Agendada", new { codigo = codigo });
        }

        // POST: principal/academica/printar/ACAD201520007/20150123
        [HttpPost]
        public ActionResult Printar(string codAvaliacao, string imageData)
        {
            if (Sessao.UsuarioCategoriaCodigo == Categoria.ALUNO)
            {
                Sistema.TempDataUrlImage[codAvaliacao] = imageData;
                return Json(true);
            }
            else if (Sessao.UsuarioCategoriaCodigo == Categoria.PROFESSOR)
            {
                string temp = Sistema.TempDataUrlImage[codAvaliacao];
                Sistema.TempDataUrlImage[codAvaliacao] = String.Empty;
                return Json(temp);
            }
            return Json(false);
        }

        // GET: principal/academica/realizar/ACAD2015200007
        [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.ALUNO })]
        public ActionResult Realizar(string codigo)
        {
            if (Sessao.UsuarioCategoriaCodigo == Categoria.ALUNO && !String.IsNullOrWhiteSpace(codigo))
            {
                AvalAcademica avalAcad = AvalAcademica.ListarPorCodigoAvaliacao(codigo);
                if (avalAcad.Avaliacao.FlagPendente
                    && avalAcad.Avaliacao.FlagLiberada
                    && avalAcad.Avaliacao.FlagAgora
                    && avalAcad.Alunos.FirstOrDefault(a => a.MatrAluno == Sessao.UsuarioMatricula) != null)
                {
                    Sessao.Inserir("RealizandoAvaliacao", true);
                    return View(avalAcad);
                }
            }
            return RedirectToAction("Agendada", new { codigo = codigo });
        }

        // POST: principal/academica/resultado/ACAD201520001
        [HttpPost]
        [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.ALUNO })]
        public ActionResult Resultado(string codigo, FormCollection form)
        {
            int codPessoaFisica = Usuario.ObterPessoaFisica(Helpers.Sessao.UsuarioMatricula);
            if (!String.IsNullOrWhiteSpace(codigo))
            {
                AvalAcademica aval = AvalAcademica.ListarPorCodigoAvaliacao(codigo);
                if (aval.Alunos.SingleOrDefault(a => a.MatrAluno == Sessao.UsuarioMatricula) != null && aval.Avaliacao.AvalPessoaResultado.SingleOrDefault(a => a.CodPessoaFisica == codPessoaFisica) == null)
                {
                    var avalPessoaResultado = new AvalPessoaResultado();
                    avalPessoaResultado.CodPessoaFisica = codPessoaFisica;
                    avalPessoaResultado.HoraTermino = DateTime.Now;
                    avalPessoaResultado.QteAcertoObj = 0;

                    double quantidadeObjetiva = 0;

                    foreach (var avaliacaoTema in aval.Avaliacao.AvaliacaoTema)
                    {
                        foreach (var avalTemaQuestao in avaliacaoTema.AvalTemaQuestao)
                        {
                            var avalQuesPessoaResposta = new AvalQuesPessoaResposta();
                            avalQuesPessoaResposta.CodPessoaFisica = codPessoaFisica;
                            if (avalTemaQuestao.QuestaoTema.Questao.CodTipoQuestao == TipoQuestao.OBJETIVA)
                            {
                                quantidadeObjetiva++;
                                int respAlternativa = -1;
                                string strRespAlternativa = form["rdoResposta" + avalTemaQuestao.QuestaoTema.Questao.CodQuestao];
                                if (!String.IsNullOrWhiteSpace(strRespAlternativa))
                                {
                                    int.TryParse(strRespAlternativa, out respAlternativa);
                                }
                                avalQuesPessoaResposta.RespAlternativa = respAlternativa;
                                if (avalTemaQuestao.QuestaoTema.Questao.Alternativa.First(q => q.FlagGabarito).CodOrdem == avalQuesPessoaResposta.RespAlternativa)
                                {
                                    avalQuesPessoaResposta.RespNota = 10;
                                    avalPessoaResultado.QteAcertoObj++;
                                }
                                else
                                {
                                    avalQuesPessoaResposta.RespNota = 0;
                                }
                            }
                            else
                            {
                                avalQuesPessoaResposta.RespDiscursiva = form["txtResposta" + avalTemaQuestao.QuestaoTema.Questao.CodQuestao].Trim();
                            }
                            avalQuesPessoaResposta.RespComentario = !String.IsNullOrWhiteSpace(form["txtComentario" + avalTemaQuestao.QuestaoTema.Questao.CodQuestao]) ? form["txtComentario" + avalTemaQuestao.QuestaoTema.Questao.CodQuestao].Trim() : null;
                            avalTemaQuestao.AvalQuesPessoaResposta.Add(avalQuesPessoaResposta);
                        }
                    }

                    IEnumerable<AvalQuesPessoaResposta> lstAvalQuesPessoaResposta = aval.Avaliacao.PessoaResposta.Where(r => r.CodPessoaFisica == codPessoaFisica);

                    avalPessoaResultado.Nota = lstAvalQuesPessoaResposta.Average(r => r.RespNota);
                    aval.Avaliacao.AvalPessoaResultado.Add(avalPessoaResultado);

                    Repositorio.Commit();

                    var model = new AvaliacaoResultadoViewModel();
                    model.Avaliacao = aval.Avaliacao;
                    model.Porcentagem = (avalPessoaResultado.QteAcertoObj.Value / quantidadeObjetiva) * 100;

                    Sessao.Inserir("RealizandoAvaliacao", false);

                    return View(model);
                }
                return RedirectToAction("Detalhe", new { codigo = aval.Avaliacao.CodAvaliacao });
            }
            return RedirectToAction("Index");
        }

        // POST: principal/academica/desistir/ACAD201520016
        [HttpPost]
        [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.ALUNO })]
        public void Desistir(string codigo)
        {
            int codPessoaFisica = Usuario.ObterPessoaFisica(Sessao.UsuarioMatricula);
            if (!String.IsNullOrWhiteSpace(codigo))
            {
                AvalAcademica aval = AvalAcademica.ListarPorCodigoAvaliacao(codigo);
                if (aval.Alunos.SingleOrDefault(a => a.MatrAluno == Sessao.UsuarioMatricula) != null && aval.Avaliacao.AvalPessoaResultado.SingleOrDefault(a => a.CodPessoaFisica == codPessoaFisica) == null)
                {
                    var avalPessoaResultado = new AvalPessoaResultado();
                    avalPessoaResultado.CodPessoaFisica = codPessoaFisica;
                    avalPessoaResultado.HoraTermino = DateTime.Now;
                    avalPessoaResultado.QteAcertoObj = 0;
                    avalPessoaResultado.Nota = 0;

                    foreach (var avaliacaoTema in aval.Avaliacao.AvaliacaoTema)
                    {
                        foreach (var avalTemaQuestao in avaliacaoTema.AvalTemaQuestao)
                        {
                            var avalQuesPessoaResposta = new AvalQuesPessoaResposta();
                            avalQuesPessoaResposta.CodPessoaFisica = codPessoaFisica;
                            if (avalTemaQuestao.QuestaoTema.Questao.CodTipoQuestao == TipoQuestao.OBJETIVA) avalQuesPessoaResposta.RespAlternativa = -1;
                            avalQuesPessoaResposta.RespNota = 0;
                            avalTemaQuestao.AvalQuesPessoaResposta.Add(avalQuesPessoaResposta);
                        }
                    }

                    aval.Avaliacao.AvalPessoaResultado.Add(avalPessoaResultado);

                    Repositorio.Commit();
                    Sessao.Inserir("RealizandoAvaliacao", false);
                }
            }
        }

        // POST: principal/academica/pendente
        [HttpGet]
        [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.PROFESSOR })]
        public ActionResult Pendente()
        {
            string matricula = Sessao.UsuarioMatricula;
            int codProfessor = Professor.ListarPorMatricula(matricula).CodProfessor;
            return View(AvalAcademica.ListarCorrecaoPendentePorProfessor(codProfessor));
        }

        // GET: historico/avaliacao/academica/corrigir/ACAD201520016
        [HttpGet]
        [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.PROFESSOR })]
        public ActionResult Corrigir(string codigo)
        {
            if (!String.IsNullOrWhiteSpace(codigo))
            {
                AvalAcademica acad = AvalAcademica.ListarPorCodigoAvaliacao(codigo);

                if (acad != null && acad.Avaliacao.FlagCorrecaoPendente && acad.Professor.MatrProfessor == Sessao.UsuarioMatricula)
                {
                    return View(acad);
                }
            }
            return RedirectToAction("Index");
        }

        // POST: principal/academica/arquivar
        [HttpPost]
        [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.PROFESSOR })]
        public ActionResult Arquivar(string codigo)
        {
            if (!String.IsNullOrWhiteSpace(codigo) && !Sistema.AvaliacaoUsuario.ContainsKey(codigo))
            {
                return Json(Avaliacao.AlternarFlagArquivo(codigo));
            }
            return Json(false);
        }

        // POST: principal/academica/avaliacao/carregaralunos/ACAD201520016
        [HttpPost]
        [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.PROFESSOR })]
        public ActionResult CarregarAlunos(string codigo)
        {
            if (!String.IsNullOrWhiteSpace(codigo))
            {
                AvalAcademica acad = AvalAcademica.ListarPorCodigoAvaliacao(codigo);
                var retorno = from alunos in acad.AlunosRealizaram
                              select new
                              {
                                  Matricula = alunos.MatrAluno,
                                  Nome = alunos.Usuario.PessoaFisica.Nome,
                                  FlagCorrecaoPendente = acad.Avaliacao.AvalPessoaResultado.Single(r => r.CodPessoaFisica == alunos.Usuario.CodPessoaFisica).FlagParcial
                              };
                return Json(retorno);
            }
            return Json(null);
        }

        // POST: principal/academica/avaliacao/carregarquestoesdiscursivas/ACAD201520016
        [HttpPost]
        [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.PROFESSOR })]
        public ActionResult CarregarQuestoesDiscursivas(string codigo)
        {
            if (!String.IsNullOrWhiteSpace(codigo))
            {
                AvalAcademica acad = AvalAcademica.ListarPorCodigoAvaliacao(codigo);
                var retorno = from questao in acad.Avaliacao.Questao
                              where questao.CodTipoQuestao == TipoQuestao.DISCURSIVA
                              orderby questao.CodQuestao
                              select new
                              {
                                  codQuestao = questao.CodQuestao,
                                  questaoEnunciado = questao.Enunciado,
                                  questaoChaveResposta = questao.ChaveDeResposta,
                                  flagCorrecaoPendente = acad.Avaliacao.PessoaResposta.Where(r => r.CodQuestao == questao.CodQuestao && !r.RespNota.HasValue).Count() > 0
                              };
                return Json(retorno);
            }
            return Json(null);
        }

        // POST: principal/academica/avaliacao/carregarrespostasdiscursivas/ACAD201520016/20150123
        [HttpPost]
        [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.PROFESSOR })]
        public ActionResult CarregarRespostasDiscursivas(string codigo, string matrAluno)
        {
            if (!String.IsNullOrWhiteSpace(codigo) && !String.IsNullOrWhiteSpace(matrAluno))
            {
                AvalAcademica acad = AvalAcademica.ListarPorCodigoAvaliacao(codigo);
                Aluno aluno = Aluno.ListarPorMatricula(matrAluno);
                int codPessoaFisica = aluno.Usuario.PessoaFisica.CodPessoa;

                var retorno = from alunoResposta in acad.Avaliacao.PessoaResposta
                              orderby alunoResposta.CodQuestao
                              where alunoResposta.CodPessoaFisica == codPessoaFisica
                                 && alunoResposta.AvalTemaQuestao.QuestaoTema.Questao.CodTipoQuestao == TipoQuestao.DISCURSIVA
                              select new
                              {
                                  codQuestao = alunoResposta.CodQuestao,
                                  questaoEnunciado = alunoResposta.AvalTemaQuestao.QuestaoTema.Questao.Enunciado,
                                  questaoChaveResposta = alunoResposta.AvalTemaQuestao.QuestaoTema.Questao.ChaveDeResposta,
                                  alunoResposta = alunoResposta.RespDiscursiva,
                                  notaObtida = alunoResposta.RespNota.HasValue ? alunoResposta.RespNota.Value.ToValueHtml() : "",
                                  correcaoComentario = alunoResposta.ProfObservacao != null ? alunoResposta.ProfObservacao : "",
                                  flagCorrigida = alunoResposta.RespNota != null ? true : false
                              };
                return Json(retorno);
            }
            return Json(null);
        }

        // POST: principal/academica/avaliacao/carregarrespostasporquestao/ACAD201520016/2699
        [HttpPost]
        [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.PROFESSOR })]
        public ActionResult CarregarRespostasPorQuestao(string codigo, string codQuestao)
        {
            if (!StringExt.IsNullOrWhiteSpace(codigo, codQuestao))
            {
                AvalAcademica acad = AvalAcademica.ListarPorCodigoAvaliacao(codigo);
                int codQuestaoTemp = int.Parse(codQuestao);

                var retorno = from questao in acad.Avaliacao.PessoaResposta
                              orderby questao.PessoaFisica.Nome
                              where questao.CodQuestao == codQuestaoTemp
                                 && questao.AvalTemaQuestao.QuestaoTema.Questao.CodTipoQuestao == TipoQuestao.DISCURSIVA
                              select new
                              {
                                  alunoMatricula = acad.AlunosRealizaram.FirstOrDefault(a => a.Usuario.CodPessoaFisica == questao.CodPessoaFisica).Usuario.Matricula,
                                  alunoNome = questao.PessoaFisica.Nome,
                                  codQuestao = questao.CodQuestao,
                                  questaoEnunciado = questao.AvalTemaQuestao.QuestaoTema.Questao.Enunciado,
                                  questaoChaveResposta = questao.AvalTemaQuestao.QuestaoTema.Questao.ChaveDeResposta,
                                  alunoResposta = questao.RespDiscursiva,
                                  notaObtida = questao.RespNota.HasValue ? questao.RespNota.Value.ToValueHtml() : "",
                                  correcaoComentario = questao.ProfObservacao != null ? questao.ProfObservacao : "",
                                  flagCorrigida = questao.RespNota != null ? true : false
                              };
                return Json(retorno);
            }
            return Json(null);
        }

        // POST: principal/academica/avaliacao/corrigirquestaoaluno/ACAD201520016/20120065/2699
        [HttpPost]
        [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.PROFESSOR })]
        public ActionResult CorrigirQuestaoAluno(string codigo, string matrAluno, string codQuestao, string notaObtida, string profObservacao)
        {
            if (!StringExt.IsNullOrWhiteSpace(codigo, matrAluno, codQuestao))
            {
                int codQuesTemp = int.Parse(codQuestao);
                double nota = Double.Parse(notaObtida.Replace('.', ','));

                bool retorno = AvalAcademica.CorrigirQuestaoAluno(codigo, matrAluno, codQuesTemp, nota, profObservacao);

                return Json(retorno);
            }
            return Json(false);
        }

        // POST: principal/academica/avaliacao/detalheindividual/ACAD201520016/20120065
        [HttpPost]
        [Filters.AutenticacaoFilter(Categorias = new[] { Categoria.PROFESSOR })]
        public ActionResult DetalheIndividual(string codigo, string matricula)
        {
            if (!StringExt.IsNullOrWhiteSpace(codigo, matricula))
            {
                AvalAcademica acad = AvalAcademica.ListarPorCodigoAvaliacao(codigo);
                if (acad != null)
                {
                    int codPessoaFisica = Usuario.ObterPessoaFisica(matricula);
                    AvalPessoaResultado model = acad.Avaliacao.AvalPessoaResultado.SingleOrDefault(r => r.CodPessoaFisica == codPessoaFisica);
                    if (model != null)
                    {
                        return PartialView("_Individual", model);
                    }
                }
            }
            return null;
        }
    }
}