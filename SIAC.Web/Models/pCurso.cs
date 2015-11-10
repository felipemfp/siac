﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SIAC.Models
{
    public partial class Curso
    {
        private static dbSIACEntities contexto { get { return Repositorio.GetInstance(); } }

        public static List<Curso> ListarOrdenadamente()
        {
            return contexto.Curso.OrderBy(c => c.Descricao).ToList();
        }

        public static Curso ListarPorCodigo(int codCurso) {
            return contexto.Curso.SingleOrDefault(c => c.CodCurso == codCurso);
        }

        public static void Inserir(Curso curso)
        {
            curso.CodCurso = ObterCodCurso();
            contexto.Curso.Add(curso);
            contexto.SaveChanges();
        }

        public static int ObterCodCurso()
        {
            int codCurso = contexto.Curso.Max(c => c.CodCurso);
            return codCurso + 1;
        }
    }
}