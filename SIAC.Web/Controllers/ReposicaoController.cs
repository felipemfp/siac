﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using SIAC.Models;
using SIAC.Helpers;

namespace SIAC.Controllers
{
    [Filters.AutenticacaoFilter(Categorias = new[] { 1, 2 })]
    public class ReposicaoController : Controller
    {
        public List<AvalAcadReposicao> Reposicoes
        {
            get
            {
                if (Sessao.UsuarioCategoriaCodigo == 2)
                {
                    int codProfessor = Professor.ListarPorMatricula(Sessao.UsuarioMatricula).CodProfessor;
                    return AvalAcadReposicao.ListarPorProfessor(codProfessor);
                }
                else
                {
                    int codAluno = Aluno.ListarPorMatricula(Sessao.UsuarioMatricula).CodAluno;
                    return AvalAcadReposicao.ListarPorAluno(codAluno);
                }
            }
        }

        // POST: Reposicao/Listar
        [HttpPost]
        public ActionResult Listar(int? pagina, string pesquisa, string ordenar, string[] categorias, string disciplina)
        {
            var qte = 12;
            var reposicoes = Reposicoes;
            pagina = pagina ?? 1;
            if (!String.IsNullOrWhiteSpace(pesquisa))
            {
                reposicoes = reposicoes.Where(a => a.Avaliacao.CodAvaliacao.ToLower().Contains(pesquisa.ToLower())).ToList();
            }

            if (!String.IsNullOrWhiteSpace(disciplina))
            {
                reposicoes = reposicoes.Where(a => a.Disciplina.CodDisciplina == int.Parse(disciplina)).ToList();
            }

            if (categorias != null)
            {
                if (categorias.Contains("agendada") && !categorias.Contains("arquivo") && !categorias.Contains("realizada"))
                {
                    reposicoes = reposicoes.Where(a => a.Avaliacao.FlagAgendada).ToList();
                }
                else if (!categorias.Contains("agendada") && categorias.Contains("arquivo") && !categorias.Contains("realizada"))
                {
                    reposicoes = reposicoes.Where(a => a.Avaliacao.FlagArquivo).ToList();
                }
                else if (!categorias.Contains("agendada") && !categorias.Contains("arquivo") && categorias.Contains("realizada"))
                {
                    reposicoes = reposicoes.Where(a => a.Avaliacao.FlagRealizada).ToList();
                }
                else if (!categorias.Contains("agendada") && categorias.Contains("arquivo") && categorias.Contains("realizada"))
                {
                    reposicoes = reposicoes.Where(a => a.Avaliacao.FlagRealizada || a.Avaliacao.FlagArquivo).ToList();
                }
                else if (categorias.Contains("agendada") && !categorias.Contains("arquivo") && categorias.Contains("realizada"))
                {
                    reposicoes = reposicoes.Where(a => a.Avaliacao.FlagRealizada || a.Avaliacao.FlagAgendada).ToList();
                }
                else if (categorias.Contains("agendada") && categorias.Contains("arquivo") && !categorias.Contains("realizada"))
                {
                    reposicoes = reposicoes.Where(a => a.Avaliacao.FlagArquivo || a.Avaliacao.FlagAgendada).ToList();
                }
            }

            switch (ordenar)
            {
                case "data_desc":
                    reposicoes = reposicoes.OrderByDescending(a => a.Avaliacao.DtCadastro).ToList();
                    break;
                case "data":
                    reposicoes = reposicoes.OrderBy(a => a.Avaliacao.DtCadastro).ToList();
                    break;
                default:
                    reposicoes = reposicoes.OrderByDescending(a => a.Avaliacao.DtCadastro).ToList();
                    break;
            }

            return PartialView("_ListaReposicao", reposicoes.Skip((qte * pagina.Value) - qte).Take(qte).ToList());
        }

        // GET: Reposicao
        public ActionResult Index()
        {
            if (Request.Url.ToString().ToLower().Contains("dashboard"))
            {
                return Redirect("~/historico/avaliacao/reposicao");
            }
            var model = new ViewModels.AvaliacaoIndexViewModel();
            model.Disciplinas = Reposicoes.Select(a => a.Disciplina).Distinct().ToList();
            return View(model);
        }

        // GET: Reposicao/Justificar/ACAD201520002
        [HttpGet]
        [Filters.AutenticacaoFilter(Categorias = new[] { 2 })]
        public ActionResult Justificar(string codigo)
        {
            var aval = AvalAcademica.ListarPorCodigoAvaliacao(codigo);
            if (aval.Professor.Usuario.Matricula == Sessao.UsuarioMatricula)
            {
                return View(aval);
            }
            return RedirectToAction("Index");
        }

        [HttpPost]
        [Filters.AutenticacaoFilter(Categorias = new[] { 2 })]
        public ActionResult Justificar(string codigo, Dictionary<string, string> justificacao)
        {
            var aval = AvalAcademica.ListarPorCodigoAvaliacao(codigo);
            if (aval.Professor.Usuario.Matricula == Sessao.UsuarioMatricula)
            {
                if (Usuario.Verificar(justificacao["senha"]))
                {
                    Aluno aluno = Aluno.ListarPorMatricula(justificacao["aluno"]);
                    AvalPessoaResultado apr = aval.Avaliacao.AvalPessoaResultado.FirstOrDefault(p => p.CodPessoaFisica == aluno.Usuario.CodPessoaFisica);
                    if (apr == null)
                    {
                        AvalPessoaResultado avalPessoaResultado = new AvalPessoaResultado();
                        avalPessoaResultado.CodPessoaFisica = aluno.Usuario.CodPessoaFisica;
                        avalPessoaResultado.HoraTermino = aval.Avaliacao.DtAplicacao;
                        avalPessoaResultado.QteAcertoObj = 0;
                        avalPessoaResultado.Nota = 0;

                        avalPessoaResultado.Justificacao.Add(new Justificacao()
                        {
                            Professor = aval.Professor,
                            DtCadastro = DateTime.Parse(justificacao["cadastro"]),
                            DtConfirmacao = DateTime.Parse(justificacao["confirmacao"]),
                            Descricao = justificacao["descricao"]
                        });

                        aval.Avaliacao.AvalPessoaResultado.Add(avalPessoaResultado);

                        Repositorio.GetInstance().SaveChanges();
                    }
                }
            }
            return null;
        }

        [HttpPost]
        [Filters.AutenticacaoFilter(Categorias = new[] { 2 })]
        public string Gerar(string codigo, int[] justificaticoes, bool nova = false)
        {
            var hoje = DateTime.Now;

            AvalAcadReposicao aval = new AvalAcadReposicao();
            AvalAcademica acad = AvalAcademica.ListarPorCodigoAvaliacao(codigo);

            aval.Avaliacao = new Avaliacao();

            aval.Avaliacao.TipoAvaliacao = TipoAvaliacao.ListarPorCodigo(5);
            aval.Avaliacao.Ano = hoje.Year;
            aval.Avaliacao.Semestre = hoje.Month > 6 ? 2 : 1;
            aval.Avaliacao.NumIdentificador = Avaliacao.ObterNumIdentificador(5);
            aval.Avaliacao.DtCadastro = hoje;

            if (nova)
            {
                List<QuestaoTema> lstQuestoes = new List<QuestaoTema>();
                var lstAvaliacaoTema = acad.Avaliacao.AvaliacaoTema.ToList();
                var qteObjetiva = lstAvaliacaoTema.QteQuestoesPorTipo(1);
                var qteDiscursiva = lstAvaliacaoTema.QteQuestoesPorTipo(2);
                var arrTemaCods = lstAvaliacaoTema.Select(a => a.CodTema.ToString()).ToArray();
                var codDificuldade = acad.Avaliacao.Questao.Max(a => a.CodDificuldade);

                if (qteObjetiva > 0)
                {
                    lstQuestoes.AddRange(Questao.ListarPorDisciplina(acad.CodDisciplina, arrTemaCods, codDificuldade, 1, qteObjetiva));
                }
                if (qteDiscursiva > 0)
                {
                    lstQuestoes.AddRange(Questao.ListarPorDisciplina(acad.CodDisciplina, arrTemaCods, codDificuldade, 2, qteDiscursiva));
                }

                foreach (var strTemaCod in arrTemaCods)
                {
                    AvaliacaoTema avalTema = new AvaliacaoTema();
                    avalTema.Tema = Tema.ListarPorCodigo(acad.CodDisciplina, int.Parse(strTemaCod));
                    foreach (var queTma in lstQuestoes.Where(q => q.CodTema == int.Parse(strTemaCod)))
                    {
                        AvalTemaQuestao avalTemaQuestao = new AvalTemaQuestao();
                        avalTemaQuestao.QuestaoTema = queTma;
                        avalTema.AvalTemaQuestao.Add(avalTemaQuestao);
                    }
                    aval.Avaliacao.AvaliacaoTema.Add(avalTema);
                }
            }
            else
            {
                foreach (var avaliacaoTema in acad.Avaliacao.AvaliacaoTema)
                {
                    aval.Avaliacao.AvaliacaoTema.Add(new AvaliacaoTema
                    {
                        Tema = avaliacaoTema.Tema,
                        AvalTemaQuestao = avaliacaoTema.AvalTemaQuestao.Select(a => new AvalTemaQuestao { QuestaoTema = a.QuestaoTema }).ToList()
                    });
                }
            }

            foreach (var codJustificacao in justificaticoes)
            {
                aval.Justificacao.Add(acad.Justificacoes.First(j => j.CodJustificacao == codJustificacao));
            }

            Repositorio.GetInstance().AvalAcadReposicao.Add(aval);
            Repositorio.GetInstance().SaveChanges();

            return nova ? Url.Action("Configurar", new { codigo = aval.Avaliacao.CodAvaliacao }) : Url.Action("Agendar", new { codigo = aval.Avaliacao.CodAvaliacao });
        }

        [Filters.AutenticacaoFilter(Categorias = new[] { 2 })]
        public ActionResult Configurar(string codigo)
        {
            TempData["listaQuestoesAntigas"] = new List<AvalTemaQuestao>();
            TempData["listaQuestoesNovas"] = new List<AvalTemaQuestao>();
            TempData["listaQuestoesPossiveisObj"] = new List<QuestaoTema>();
            TempData["listaQuestoesPossiveisDisc"] = new List<QuestaoTema>();
            TempData["listaQuestoesIndices"] = new List<int>();
            TempData["listaQuestoesRecentes"] = new List<int>();

            if (!String.IsNullOrEmpty(codigo))
            {
                AvalAcadReposicao repo = AvalAcadReposicao.ListarPorCodigoAvaliacao(codigo);
                if (repo != null && repo.Professor.MatrProfessor == Sessao.UsuarioMatricula && repo.Avaliacao.AvalPessoaResultado.Count == 0)
                {
                    return View(repo);
                }
            }
            return RedirectToAction("Index");
        }

        [HttpPost]
        [Filters.AutenticacaoFilter(Categorias = new[] { 2 })]
        public ActionResult TrocarQuestao(string codigoAvaliacao, int tipo, int indice, int codQuestao)
        {
            List<AvalTemaQuestao> antigas = (List<AvalTemaQuestao>)TempData["listaQuestoesAntigas"];
            List<AvalTemaQuestao> novas = (List<AvalTemaQuestao>)TempData["listaQuestoesNovas"];
            List<QuestaoTema> questoesTrocaObj = (List<QuestaoTema>)TempData["listaQuestoesPossiveisObj"];
            List<QuestaoTema> questoesTrocaDisc = (List<QuestaoTema>)TempData["listaQuestoesPossiveisDisc"];
            List<int> indices = (List<int>)TempData["listaQuestoesIndices"];
            List<int> recentes = (List<int>)TempData["listaQuestoesRecentes"];

            TempData.Keep();
            Random r = new Random();

            if (!String.IsNullOrEmpty(codigoAvaliacao))
            {
                AvalAcadReposicao repo = AvalAcadReposicao.ListarPorCodigoAvaliacao(codigoAvaliacao);
                if (repo != null && repo.Professor.MatrProfessor == Sessao.UsuarioMatricula)
                {
                    List<QuestaoTema> AvalQuestTema = repo.Avaliacao.QuestaoTema;

                    QuestaoTema questao = null;

                    if (tipo == 1)
                    {
                        if (questoesTrocaObj.Count <= 0)
                        {
                            TempData["listaQuestoesPossiveisObj"] = Questao.ObterNovasQuestoes(AvalQuestTema, tipo);
                            questoesTrocaObj = (List<QuestaoTema>)TempData["listaQuestoesPossiveisObj"];
                        }

                        int random = r.Next(0, questoesTrocaObj.Count);
                        questao = questoesTrocaObj.ElementAtOrDefault(random);
                    }
                    else if (tipo == 2)
                    {
                        if (questoesTrocaDisc.Count <= 0)
                        {
                            TempData["listaQuestoesPossiveisDisc"] = Questao.ObterNovasQuestoes(AvalQuestTema, tipo);
                            questoesTrocaDisc = (List<QuestaoTema>)TempData["listaQuestoesPossiveisDisc"];
                        }

                        int random = r.Next(0, questoesTrocaDisc.Count);
                        questao = questoesTrocaDisc.ElementAtOrDefault(random);
                    }

                    if (questao != null)
                    {
                        if (!indices.Contains(indice))
                        {
                            AvalTemaQuestao aqtAntiga = (from atq in Repositorio.GetInstance().AvalTemaQuestao
                                                         where atq.Ano == repo.Ano
                                                         && atq.Semestre == repo.Semestre
                                                         && atq.CodTipoAvaliacao == repo.CodTipoAvaliacao
                                                         && atq.NumIdentificador == repo.NumIdentificador
                                                         && atq.CodQuestao == codQuestao
                                                         select atq).FirstOrDefault();
                            antigas.Add(aqtAntiga);
                            indices.Add(indice);
                        }

                        int index = indices.IndexOf(indice);

                        AvalTemaQuestao atqNova = new AvalTemaQuestao();
                        atqNova.Ano = repo.Avaliacao.Ano;
                        atqNova.Semestre = repo.Avaliacao.Semestre;
                        atqNova.CodTipoAvaliacao = repo.Avaliacao.CodTipoAvaliacao;
                        atqNova.NumIdentificador = repo.Avaliacao.NumIdentificador;
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
                        return PartialView("_Questao", questao.Questao);
                    }
                }
            }

            return Json(String.Empty);
        }

        [HttpPost]
        [Filters.AutenticacaoFilter(Categorias = new[] { 2 })]
        public ActionResult Desfazer(string codigoAvaliacao, int tipo, int indice, int codQuestao)
        {
            List<AvalTemaQuestao> antigas = (List<AvalTemaQuestao>)TempData["listaQuestoesAntigas"];
            List<AvalTemaQuestao> novas = (List<AvalTemaQuestao>)TempData["listaQuestoesNovas"];
            List<QuestaoTema> questoesTrocaObj = (List<QuestaoTema>)TempData["listaQuestoesPossiveisObj"];
            List<QuestaoTema> questoesTrocaDisc = (List<QuestaoTema>)TempData["listaQuestoesPossiveisDisc"];
            List<int> indices = (List<int>)TempData["listaQuestoesIndices"];
            List<int> recentes = (List<int>)TempData["listaQuestoesRecentes"];

            TempData.Keep();

            if (!String.IsNullOrEmpty(codigoAvaliacao))
            {
                int codQuestaoRecente = recentes[indices.IndexOf(indice)];

                QuestaoTema questao = null;

                if (tipo == 1)
                {
                    questao = questoesTrocaObj.FirstOrDefault(qt => qt.CodQuestao == codQuestaoRecente);
                    if (questao == null)
                    {
                        questao = antigas[indices.IndexOf(indice)].QuestaoTema;
                    }
                }
                else if (tipo == 2)
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
                    return PartialView("_Questao", questao.Questao);
                }
            }

            return Json(String.Empty);
        }

        [HttpPost]
        [Filters.AutenticacaoFilter(Categorias = new[] { 2 })]
        public ActionResult Salvar(string codigo)
        {
            List<AvalTemaQuestao> antigas = (List<AvalTemaQuestao>)TempData["listaQuestoesAntigas"];
            List<AvalTemaQuestao> novas = (List<AvalTemaQuestao>)TempData["listaQuestoesNovas"];

            if (antigas.Count != 0 && novas.Count != 0)
            {
                var contexto = Repositorio.GetInstance();
                for (int i = 0; i < antigas.Count && i < novas.Count; i++)
                {
                    contexto.AvalTemaQuestao.Remove(antigas.ElementAtOrDefault(i));
                    contexto.AvalTemaQuestao.Add(novas.ElementAtOrDefault(i));
                }
                contexto.SaveChanges();
            }
            TempData.Clear();

            return RedirectToAction("Agendar", new { codigo = codigo });
        }

        [HttpGet]
        [Filters.AutenticacaoFilter(Categorias = new[] { 2 })]
        public ActionResult Agendar(string codigo)
        {
            if (String.IsNullOrEmpty(codigo))
            {
                return RedirectToAction("Index");
            }

            var aval = AvalAcadReposicao.ListarPorCodigoAvaliacao(codigo);

            if (aval.Professor.MatrProfessor == Sessao.UsuarioMatricula)
            {
                var model = new ViewModels.AvaliacaoAgendarViewModel();

                model.Avaliacao = aval.Avaliacao;
                model.Salas = Sala.ListarOrdenadamente();

                return View(model);
            }
            return RedirectToAction("Index");
        }

        [HttpPost]
        [Filters.AutenticacaoFilter(Categorias = new[] { 2 })]
        public ActionResult Agendar(string codigo, FormCollection form)
        {
            string strCodSala = form["ddlSala"];
            string strData = form["txtData"];
            string strHoraInicio = form["txtHoraInicio"];
            string strHoraTermino = form["txtHoraTermino"];
            if (!StringExt.IsNullOrWhiteSpace(strCodSala, strData, strHoraInicio, strHoraTermino))
            {
                var aval = AvalAcadReposicao.ListarPorCodigoAvaliacao(codigo);

                if (aval.Professor.MatrProfessor == Sessao.UsuarioMatricula)
                {
                    // Sala
                    int codSala;
                    int.TryParse(strCodSala, out codSala);
                    Sala sala = Sala.ListarPorCodigo(codSala);
                    if (sala != null)
                    {
                        aval.Sala = sala;
                    }

                    // Data de Aplicacao
                    DateTime dtAplicacao = DateTime.Parse(strData + " " + strHoraInicio);
                    DateTime dtAplicacaoTermino = DateTime.Parse(strData + " " + strHoraTermino);

                    if (dtAplicacao.IsFuture() && dtAplicacaoTermino.IsFuture() && dtAplicacaoTermino > dtAplicacao)
                    {
                        aval.Avaliacao.DtAplicacao = dtAplicacao;
                        aval.Avaliacao.Duracao = Convert.ToInt32((dtAplicacaoTermino - aval.Avaliacao.DtAplicacao.Value).TotalMinutes);
                    }

                    aval.Avaliacao.FlagLiberada = false;

                    Repositorio.GetInstance().SaveChanges();
                }
            }

            return RedirectToAction("Agendada", new { codigo = codigo });
        }

        [HttpGet]
        [Filters.AutenticacaoFilter(Categorias = new[] { 2 })]
        public ActionResult Agendada(string codigo)
        {
            return null;
        }
    }
}