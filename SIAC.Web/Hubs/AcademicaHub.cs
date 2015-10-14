﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;

namespace SIAC.Web.Hubs
{
    public class AcademicaHub : Hub
    {
        private readonly static AcademicaMapping avaliacoes = new AcademicaMapping();

        public void Realizar(string codAvaliacao)
        {
            Groups.Add(Context.ConnectionId, codAvaliacao);
        }

        public void Liberar(string codAvaliacao, bool flag)
        {
            if (flag)
            {
                Clients.Group(codAvaliacao).liberar(codAvaliacao);
            }
            else
            {
                Clients.Group(codAvaliacao).bloquear(codAvaliacao);
            }
        }

        public void ProfessorConectou(string codAvaliacao, string usrMatricula)
        {
            avaliacoes.AddAcademica(codAvaliacao);
            avaliacoes.GetAcademica(codAvaliacao).AddProfessor(usrMatricula, Context.ConnectionId);
            //Groups.Add(Context.ConnectionId, "PRF" + codAvaliacao);
        }

        public void AlunoConectou(string codAvaliacao,string usrMatricula,string usrNome)
        {
            avaliacoes.AddAcademica(codAvaliacao);
            avaliacoes.GetAcademica(codAvaliacao).AddAluno(usrMatricula, Context.ConnectionId);
            //Groups.Add(Context.ConnectionId, "AVA"+codAvaliacao+"ALN"+usrMatricula);

            //Clients.Group("PRF" + codAvaliacao).addAluno(usrMatricula,usrNome);

            Clients.Client(avaliacoes.GetAcademica(codAvaliacao).GetConnectionIdProfessor()).conectarAluno(usrMatricula);
        }

        public void RequererAval(string codAvaliacao,string usrMatricula)
        {
            //Clients.Group("AVA" + codAvaliacao + "ALN" + usrMatricula).enviarAval(codAvaliacao);
            Clients.Client(avaliacoes.GetAcademica(codAvaliacao).GetConnectionIdAluno(usrMatricula)).enviarAval(codAvaliacao);
        }

        public void AvalEnviada(string codAvaliacao,string alnMatricula,string alnNome)
        {
            //Clients.Group("PRF" + codAvaliacao).receberAval(alnMatricula,alnNome);
            Clients.Client(avaliacoes.GetAcademica(codAvaliacao).GetConnectionIdProfessor()).receberAval(alnMatricula, alnNome);
        }

        public void AtualizarAlunoProgresso(string codAvaliacao, string usrMatricula, double percent)
        {
            //Clients.Group("PRF" + codAvaliacao).atualizarProgresso(usrMatricula, percent);
            Clients.Client(avaliacoes.GetAcademica(codAvaliacao).GetConnectionIdProfessor()).atualizarProgresso(usrMatricula, percent);            
        }
    }

    public class AcademicaMapping
    {
        private readonly Dictionary<string, Academica> academicas = new Dictionary<string, Academica>();

        public void AddAcademica(string codAvaliacao)
        {
            lock (academicas)
            {
                if (!academicas.ContainsKey(codAvaliacao))
                {
                    academicas.Add(codAvaliacao, new Academica());
                }
            }
        }

        public Academica GetAcademica(string codAvaliacao)
        {
            if (academicas.ContainsKey(codAvaliacao))
            {
                return academicas[codAvaliacao];
            }
            return null;
        }
    }

    public class Academica
    {
        private readonly Dictionary<string, string> alunos = new Dictionary<string, string>();
        private readonly string[,] professor = new string[1,2];

        public void AddProfessor(string matricula, string connectionId)
        {
            lock (professor)
            {
                professor[0, 0] = matricula;
                professor[0, 1] = connectionId;
            }
        }

        public void AddAluno(string matricula, string connectionId)
        {
            lock(alunos)
            {
                if (alunos.ContainsKey(matricula))
                {
                    alunos.Remove(matricula);
                }
                alunos.Add(matricula, connectionId);
            }
        }

        public string GetConnectionIdProfessor()
        {
            if (!String.IsNullOrEmpty(professor[0,1]))
            {
                return professor[0, 1];
            }
            return String.Empty;
        }

        public string GetConnectionIdAluno(string matricula)
        {
            if (alunos.ContainsKey(matricula))
            {
                return alunos[matricula];
            }
            return String.Empty;
        }

        public void RemoveAluno(string matricula)
        {
            lock(alunos)
            {
                if (alunos.ContainsKey(matricula))
                {
                    alunos.Remove(matricula);
                }
            }
        }
    }
}