USE [master]
GO
/****** Object:  Database [DB_SIAC]    Script Date: 07/11/2015 19:30:33 ******/
CREATE DATABASE [DB_SIAC] ON  PRIMARY 
( NAME = N'DB_SIAC', FILENAME = N'D:\mssqldata\DB_SIAC.mdf' , SIZE = 8448KB , MAXSIZE = 20480KB , FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'DB_SIAC_log', FILENAME = N'E:\mssqltempdbdata\DB_SIAC_log.LDF' , SIZE = 2816KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [DB_SIAC] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DB_SIAC].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DB_SIAC] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DB_SIAC] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DB_SIAC] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DB_SIAC] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DB_SIAC] SET ARITHABORT OFF 
GO
ALTER DATABASE [DB_SIAC] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DB_SIAC] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DB_SIAC] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DB_SIAC] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DB_SIAC] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DB_SIAC] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DB_SIAC] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DB_SIAC] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DB_SIAC] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DB_SIAC] SET  ENABLE_BROKER 
GO
ALTER DATABASE [DB_SIAC] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DB_SIAC] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DB_SIAC] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DB_SIAC] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DB_SIAC] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DB_SIAC] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DB_SIAC] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DB_SIAC] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [DB_SIAC] SET  MULTI_USER 
GO
ALTER DATABASE [DB_SIAC] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DB_SIAC] SET DB_CHAINING OFF 
GO
USE [DB_SIAC]
GO
/****** Object:  UserDefinedFunction [dbo].[PessoaTemCategoria]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[PessoaTemCategoria](@CodPessoaFisica integer,
                                       @CodCategoria    integer)
RETURNS int
AS
  BEGIN
      RETURN
        (SELECT Count(*)
         FROM   PessoaCategoria PC
         WHERE  PC.CodCategoria = @CodCategoria
                AND PC.CodPessoaFisica = @CodPessoaFisica)
  END


GO
/****** Object:  UserDefinedFunction [dbo].[PessoaTipoCorreto]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[PessoaTipoCorreto](@CodPessoa int, @TipoPessoa char)
RETURNS int
AS
  BEGIN
      RETURN
        (SELECT Count(*)
         FROM   Pessoa
         WHERE  Pessoa.CodPessoa = @CodPessoa
                AND Pessoa.TipoPessoa = @TipoPessoa)
  END


GO
/****** Object:  Table [dbo].[Alternativa]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Alternativa](
	[CodOrdem] [int] NOT NULL,
	[CodQuestao] [int] NOT NULL,
	[Enunciado] [text] NULL,
	[Comentario] [text] NULL,
	[FlagGabarito] [bit] NULL DEFAULT ((0)),
PRIMARY KEY CLUSTERED 
(
	[CodOrdem] ASC,
	[CodQuestao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Aluno]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Aluno](
	[CodAluno] [int] IDENTITY(1,1) NOT NULL,
	[CodCurso] [int] NOT NULL,
	[MatrAluno] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodAluno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[MatrAluno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Area]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Area](
	[CodArea] [int] IDENTITY(1,1) NOT NULL,
	[Descricao] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodArea] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AvalAcademica]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AvalAcademica](
	[NumIdentificador] [int] NOT NULL,
	[CodTipoAvaliacao] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[CodTurno] [char](1) NULL,
	[NumTurma] [int] NULL,
	[Periodo] [int] NULL,
	[CodCurso] [int] NULL,
	[CodSala] [int] NULL,
	[CodProfessor] [int] NOT NULL,
	[CodDisciplina] [int] NOT NULL,
	[Valor] [float] NULL DEFAULT ((10)),
PRIMARY KEY CLUSTERED 
(
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Semestre] ASC,
	[Ano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AvalAcadReposicao]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AvalAcadReposicao](
	[CodTipoAvaliacao] [int] NOT NULL,
	[NumIdentificador] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[CodProfessor] [int] NOT NULL,
	[CodJustificacao] [int] NOT NULL,
	[CodSala] [int] NOT NULL,
	[Valor] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[CodTipoAvaliacao] ASC,
	[NumIdentificador] ASC,
	[Semestre] ASC,
	[Ano] ASC,
	[CodProfessor] ASC,
	[CodJustificacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AvalAuto]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AvalAuto](
	[NumIdentificador] [int] NOT NULL,
	[CodTipoAvaliacao] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[CodDificuldade] [int] NOT NULL,
	[CodPessoaFisica] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Semestre] ASC,
	[Ano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AvalAvi]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AvalAvi](
	[NumIdentificador] [int] NOT NULL,
	[CodTipoAvaliacao] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[CodColabCoordenador] [int] NOT NULL,
	[Titulo] [varchar](250) NOT NULL,
	[Objetivo] [text] NOT NULL,
	[DtTermino] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Semestre] ASC,
	[Ano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AvalCertificacao]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AvalCertificacao](
	[NumIdentificador] [int] NOT NULL,
	[CodTipoAvaliacao] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[CodSala] [int] NULL,
	[CodProfessor] [int] NOT NULL,
	[CodDisciplina] [int] NOT NULL,
	[Valor] [float] NULL DEFAULT ((10)),
PRIMARY KEY CLUSTERED 
(
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Semestre] ASC,
	[Ano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AvalCertPessoa]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AvalCertPessoa](
	[CodPessoaFisica] [int] NOT NULL,
	[NumIdentificador] [int] NOT NULL,
	[CodTipoAvaliacao] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodPessoaFisica] ASC,
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Ano] ASC,
	[Semestre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Avaliacao]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Avaliacao](
	[Ano] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[NumIdentificador] [int] NOT NULL,
	[CodTipoAvaliacao] [int] NOT NULL,
	[DtCadastro] [datetime] NOT NULL DEFAULT (getdate()),
	[DtAplicacao] [datetime] NULL,
	[Duracao] [int] NULL,
	[FlagLiberada] [bit] NOT NULL DEFAULT ((0)),
	[Recomendacao] [text] NULL,
	[FlagArquivo] [bit] NOT NULL CONSTRAINT [DF_Avaliacao_FlagArquivo]  DEFAULT ((0)),
PRIMARY KEY CLUSTERED 
(
	[CodTipoAvaliacao] ASC,
	[Ano] ASC,
	[Semestre] ASC,
	[NumIdentificador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AvaliacaoTema]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AvaliacaoTema](
	[CodTema] [int] NOT NULL,
	[CodDisciplina] [int] NOT NULL,
	[NumIdentificador] [int] NOT NULL,
	[CodTipoAvaliacao] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[Ano] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodTema] ASC,
	[CodDisciplina] ASC,
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Semestre] ASC,
	[Ano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AvalPessoaResultado]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AvalPessoaResultado](
	[CodPessoaFisica] [int] NOT NULL,
	[NumIdentificador] [int] NOT NULL,
	[CodTipoAvaliacao] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[HoraTermino] [datetime] NULL,
	[QteAcertoObj] [int] NULL,
	[Nota] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[CodPessoaFisica] ASC,
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Semestre] ASC,
	[Ano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AvalQuesPessoaResposta]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AvalQuesPessoaResposta](
	[CodPessoaFisica] [int] NOT NULL,
	[CodTema] [int] NOT NULL,
	[CodDisciplina] [int] NOT NULL,
	[NumIdentificador] [int] NOT NULL,
	[CodTipoAvaliacao] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[CodQuestao] [int] NOT NULL,
	[RespAlternativa] [int] NULL,
	[RespDiscursiva] [text] NULL,
	[RespComentario] [varchar](250) NULL,
	[RespNota] [float] NULL,
	[ProfObservacao] [varchar](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodPessoaFisica] ASC,
	[CodTema] ASC,
	[CodDisciplina] ASC,
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Semestre] ASC,
	[Ano] ASC,
	[CodQuestao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AvalTemaQuestao]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AvalTemaQuestao](
	[CodTema] [int] NOT NULL,
	[CodDisciplina] [int] NOT NULL,
	[NumIdentificador] [int] NOT NULL,
	[CodTipoAvaliacao] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[CodQuestao] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodTema] ASC,
	[CodDisciplina] ASC,
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Ano] ASC,
	[Semestre] ASC,
	[CodQuestao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AviCategoria]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AviCategoria](
	[CodAviCategoria] [int] IDENTITY(1,1) NOT NULL,
	[Descricao] [varchar](100) NOT NULL,
	[Observacao] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodAviCategoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AviIndicador]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AviIndicador](
	[CodAviIndicador] [int] IDENTITY(1,1) NOT NULL,
	[Descricao] [varchar](100) NOT NULL,
	[Observacao] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodAviIndicador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AviModulo]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AviModulo](
	[CodAviModulo] [int] IDENTITY(1,1) NOT NULL,
	[Descricao] [varchar](100) NOT NULL,
	[Objetivo] [text] NULL,
	[Observacao] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodAviModulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AviPublico]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AviPublico](
	[CodOrdem] [int] NOT NULL,
	[NumIdentificador] [int] NOT NULL,
	[CodTipoAvaliacao] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[CodAviTipoPublico] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodOrdem] ASC,
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Ano] ASC,
	[Semestre] ASC,
	[CodAviTipoPublico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AviPublicoCampus]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AviPublicoCampus](
	[NumIdentificador] [int] NOT NULL,
	[CodTipoAvaliacao] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[CodOrdem] [int] NOT NULL,
	[CodAviTipoPublico] [int] NOT NULL,
	[CodCampus] [int] NOT NULL,
	[CodInstituicao] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Semestre] ASC,
	[Ano] ASC,
	[CodOrdem] ASC,
	[CodAviTipoPublico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AviPublicoCurso]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AviPublicoCurso](
	[NumIdentificador] [int] NOT NULL,
	[CodTipoAvaliacao] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[CodOrdem] [int] NOT NULL,
	[CodAviTipoPublico] [int] NOT NULL,
	[CodCurso] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Semestre] ASC,
	[Ano] ASC,
	[CodOrdem] ASC,
	[CodAviTipoPublico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AviPublicoDiretoria]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AviPublicoDiretoria](
	[NumIdentificador] [int] NOT NULL,
	[CodTipoAvaliacao] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[CodOrdem] [int] NOT NULL,
	[CodAviTipoPublico] [int] NOT NULL,
	[CodDiretoria] [int] NOT NULL,
	[CodCampus] [int] NOT NULL,
	[CodInstituicao] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Semestre] ASC,
	[Ano] ASC,
	[CodOrdem] ASC,
	[CodAviTipoPublico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AviPublicoInstituicao]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AviPublicoInstituicao](
	[NumIdentificador] [int] NOT NULL,
	[CodTipoAvaliacao] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[CodOrdem] [int] NOT NULL,
	[CodAviTipoPublico] [int] NOT NULL,
	[CodInstituicao] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Semestre] ASC,
	[Ano] ASC,
	[CodOrdem] ASC,
	[CodAviTipoPublico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AviPublicoPessoa]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AviPublicoPessoa](
	[CodAviTipoPublico] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[CodTipoAvaliacao] [int] NOT NULL,
	[NumIdentificador] [int] NOT NULL,
	[CodOrdem] [int] NOT NULL,
	[CodPessoaFisica] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodAviTipoPublico] ASC,
	[Semestre] ASC,
	[Ano] ASC,
	[CodTipoAvaliacao] ASC,
	[NumIdentificador] ASC,
	[CodOrdem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AviPublicoProReitoria]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AviPublicoProReitoria](
	[NumIdentificador] [int] NOT NULL,
	[CodTipoAvaliacao] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[CodOrdem] [int] NOT NULL,
	[CodAviTipoPublico] [int] NOT NULL,
	[CodProReitoria] [int] NOT NULL,
	[CodInstituicao] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Semestre] ASC,
	[Ano] ASC,
	[CodOrdem] ASC,
	[CodAviTipoPublico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AviPublicoReitoria]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AviPublicoReitoria](
	[NumIdentificador] [int] NOT NULL,
	[CodTipoAvaliacao] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[CodOrdem] [int] NOT NULL,
	[CodAviTipoPublico] [int] NOT NULL,
	[CodReitoria] [int] NOT NULL,
	[CodInstituicao] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Semestre] ASC,
	[Ano] ASC,
	[CodOrdem] ASC,
	[CodAviTipoPublico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AviPublicoTurma]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AviPublicoTurma](
	[NumIdentificador] [int] NOT NULL,
	[CodTipoAvaliacao] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[CodOrdem] [int] NOT NULL,
	[CodAviTipoPublico] [int] NOT NULL,
	[CodTurno] [char](1) NOT NULL,
	[NumTurma] [int] NOT NULL,
	[Periodo] [int] NOT NULL,
	[CodCurso] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Semestre] ASC,
	[Ano] ASC,
	[CodOrdem] ASC,
	[CodAviTipoPublico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AviQuestao]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AviQuestao](
	[CodOrdem] [int] NOT NULL,
	[NumIdentificador] [int] NOT NULL,
	[CodTipoAvaliacao] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[CodAviIndicador] [int] NOT NULL,
	[CodAviCategoria] [int] NOT NULL,
	[CodAviModulo] [int] NOT NULL,
	[Enunciado] [varchar](255) NOT NULL,
	[Observacao] [varchar](255) NULL,
	[FlagDiscursiva] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[CodOrdem] ASC,
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Ano] ASC,
	[Semestre] ASC,
	[CodAviIndicador] ASC,
	[CodAviCategoria] ASC,
	[CodAviModulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AviQuestaoAlternativa]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AviQuestaoAlternativa](
	[CodAlternativa] [int] NOT NULL,
	[NumIdentificador] [int] NOT NULL,
	[CodTipoAvaliacao] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[CodAviIndicador] [int] NOT NULL,
	[CodAviCategoria] [int] NOT NULL,
	[CodAviModulo] [int] NOT NULL,
	[CodOrdem] [int] NOT NULL,
	[Enunciado] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodAlternativa] ASC,
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Semestre] ASC,
	[Ano] ASC,
	[CodAviIndicador] ASC,
	[CodAviCategoria] ASC,
	[CodAviModulo] ASC,
	[CodOrdem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AviQuestaoPessoaResposta]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AviQuestaoPessoaResposta](
	[CodPessoaFisica] [int] NOT NULL,
	[NumIdentificador] [int] NOT NULL,
	[CodTipoAvaliacao] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[CodAviIndicador] [int] NOT NULL,
	[CodAviCategoria] [int] NOT NULL,
	[CodAviModulo] [int] NOT NULL,
	[CodOrdem] [int] NOT NULL,
	[CodRespostaOrdem] [int] NOT NULL,
	[RespAlternativa] [int] NULL,
	[RespDiscursiva] [text] NULL,
	[RespData] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[CodPessoaFisica] ASC,
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Semestre] ASC,
	[Ano] ASC,
	[CodAviIndicador] ASC,
	[CodAviCategoria] ASC,
	[CodAviModulo] ASC,
	[CodOrdem] ASC,
	[CodRespostaOrdem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AviTipoPublico]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AviTipoPublico](
	[CodAviTipoPublico] [int] NOT NULL,
	[Descricao] [varchar](35) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodAviTipoPublico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Bairro]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Bairro](
	[CodBairro] [int] NOT NULL,
	[CodEstado] [int] NOT NULL,
	[CodPais] [int] NOT NULL,
	[CodMunicipio] [int] NOT NULL,
	[Descricao] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodBairro] ASC,
	[CodEstado] ASC,
	[CodPais] ASC,
	[CodMunicipio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Campus]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Campus](
	[CodCampus] [int] IDENTITY(1,1) NOT NULL,
	[CodInstituicao] [int] NOT NULL,
	[CodColaboradorDiretor] [int] NOT NULL,
	[CodPessoaJuridica] [int] NOT NULL,
	[Sigla] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodCampus] ASC,
	[CodInstituicao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Categoria]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Categoria](
	[CodCategoria] [int] NOT NULL,
	[Descricao] [varchar](40) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodCategoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Colaborador]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Colaborador](
	[CodColaborador] [int] IDENTITY(1,1) NOT NULL,
	[MatrColaborador] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodColaborador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[MatrColaborador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Curso]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Curso](
	[CodCurso] [int] NOT NULL,
	[CodNivelEnsino] [int] NOT NULL,
	[CodDiretoria] [int] NOT NULL,
	[CodCampus] [int] NOT NULL,
	[CodInstituicao] [int] NOT NULL,
	[CodColabCoordenador] [int] NOT NULL,
	[Descricao] [varchar](100) NOT NULL,
	[Sigla] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodCurso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DiaSemana]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DiaSemana](
	[CodDia] [int] NOT NULL,
	[Descricao] [varchar](15) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodDia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Dificuldade]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Dificuldade](
	[CodDificuldade] [int] NOT NULL,
	[Descricao] [varchar](20) NOT NULL,
	[Comentario] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodDificuldade] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Diretoria]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Diretoria](
	[CodDiretoria] [int] IDENTITY(1,1) NOT NULL,
	[CodInstituicao] [int] NOT NULL,
	[CodCampus] [int] NOT NULL,
	[CodPessoaJuridica] [int] NOT NULL,
	[CodColaboradorDiretor] [int] NOT NULL,
	[Sigla] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodDiretoria] ASC,
	[CodInstituicao] ASC,
	[CodCampus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Disciplina]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Disciplina](
	[CodDisciplina] [int] IDENTITY(1,1) NOT NULL,
	[Descricao] [varchar](50) NOT NULL,
	[Sigla] [varchar](10) NULL,
	[FlagEletivaOptativa] [bit] NULL DEFAULT ((0)),
	[FlagFlexivel] [bit] NULL DEFAULT ((0)),
	[CodDiscIFRN] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CodDisciplina] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Email]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Email](
	[CodOrdem] [int] NOT NULL,
	[CodPessoa] [int] NOT NULL,
	[CodTipoContato] [int] NOT NULL,
	[Email] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodOrdem] ASC,
	[CodPessoa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Endereco]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Endereco](
	[CodOrdem] [int] NOT NULL,
	[CodPessoa] [int] NOT NULL,
	[CodMunicipio] [int] NOT NULL,
	[CodBairro] [int] NOT NULL,
	[CodPais] [int] NOT NULL,
	[CodEstado] [int] NOT NULL,
	[Logradouro] [varchar](100) NOT NULL,
	[Numero] [varchar](10) NOT NULL,
	[Complemento] [varchar](140) NULL,
	[Cep] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CodOrdem] ASC,
	[CodPessoa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Estado]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Estado](
	[CodEstado] [int] NOT NULL,
	[CodPais] [int] NOT NULL,
	[Descricao] [varchar](100) NOT NULL,
	[Sigla] [varchar](2) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodPais] ASC,
	[CodEstado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Horario]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Horario](
	[CodGrupo] [int] NOT NULL,
	[CodHorario] [int] NOT NULL,
	[CodTurno] [char](1) NOT NULL,
	[HoraInicio] [datetime] NULL,
	[HoraTermino] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[CodGrupo] ASC,
	[CodHorario] ASC,
	[CodTurno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Instituicao]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Instituicao](
	[CodInstituicao] [int] IDENTITY(1,1) NOT NULL,
	[CodPessoaJuridica] [int] NOT NULL,
	[Sigla] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodInstituicao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Justificacao]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Justificacao](
	[CodJustificacao] [int] IDENTITY(1,1) NOT NULL,
	[CodProfessor] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[CodTipoAvaliacao] [int] NOT NULL,
	[NumIdentificador] [int] NOT NULL,
	[CodPessoaFisica] [int] NOT NULL,
	[DtCadastro] [datetime] NOT NULL,
	[DtConfirmacao] [datetime] NULL,
	[Descricao] [text] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodJustificacao] ASC,
	[CodProfessor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MatrizCurricular]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MatrizCurricular](
	[CodMatriz] [int] NOT NULL,
	[CodCurso] [int] NOT NULL,
	[CargaHoraria] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CodMatriz] ASC,
	[CodCurso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MatrizCurricularDisciplina]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MatrizCurricularDisciplina](
	[CodCurso] [int] NOT NULL,
	[CodMatriz] [int] NOT NULL,
	[CodDisciplina] [int] NOT NULL,
	[Periodo] [int] NOT NULL,
	[DiscCargaHoraria] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodCurso] ASC,
	[CodMatriz] ASC,
	[CodDisciplina] ASC,
	[Periodo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Municipio]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Municipio](
	[CodMunicipio] [int] NOT NULL,
	[CodPais] [int] NOT NULL,
	[CodEstado] [int] NOT NULL,
	[Descricao] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodPais] ASC,
	[CodEstado] ASC,
	[CodMunicipio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NivelEnsino]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NivelEnsino](
	[CodNivelEnsino] [int] IDENTITY(1,1) NOT NULL,
	[Descricao] [varchar](30) NOT NULL,
	[Sigla] [varchar](5) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodNivelEnsino] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Ocupacao]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Ocupacao](
	[CodOcupacao] [int] IDENTITY(1,1) NOT NULL,
	[Descricao] [varchar](40) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodOcupacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Pais]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Pais](
	[CodPais] [int] IDENTITY(1,1) NOT NULL,
	[Descricao] [varchar](50) NOT NULL,
	[Sigla] [varchar](5) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodPais] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Parametro]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Parametro](
	[CodParametro] [int] IDENTITY(1,1) NOT NULL,
	[TempoInatividade] [int] NOT NULL DEFAULT ((90)),
	[NumeracaoQuestao] [int] NOT NULL DEFAULT ((1)),
	[NumeracaoAlternativa] [int] NOT NULL DEFAULT ((3)),
	[QteSemestres] [int] NOT NULL DEFAULT ((4)),
	[TermoResponsabilidade] [text] NOT NULL,
	[NotaUso] [text] NOT NULL CONSTRAINT [DF_Parametro_TermoResponsabilidadeAvaliacao]  DEFAULT ('É importante questionar o quanto a contínua expansão de nossa atividade faz parte de um processo de gerenciamento do fluxo de informações.'),
	[ValorNotaMedia] [float] NOT NULL CONSTRAINT [DF_Parametro_ValorNotaMedia]  DEFAULT ((6)),
PRIMARY KEY CLUSTERED 
(
	[CodParametro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Pessoa]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Pessoa](
	[CodPessoa] [int] IDENTITY(1,1) NOT NULL,
	[TipoPessoa] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodPessoa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PessoaCategoria]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PessoaCategoria](
	[CodPessoaFisica] [int] NOT NULL,
	[CodCategoria] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodPessoaFisica] ASC,
	[CodCategoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PessoaFisica]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PessoaFisica](
	[CodPessoa] [int] NOT NULL,
	[Nome] [varchar](100) NOT NULL,
	[DtNascimento] [datetime] NULL,
	[Cpf] [char](11) NULL,
	[Sexo] [char](1) NULL DEFAULT ('N'),
PRIMARY KEY CLUSTERED 
(
	[CodPessoa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PessoaFormacao]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PessoaFormacao](
	[CodOrdem] [int] NOT NULL,
	[CodPessoaFisica] [int] NOT NULL,
	[CodArea] [int] NOT NULL,
	[CodNivelEnsino] [int] NOT NULL,
	[Curso] [varchar](50) NOT NULL,
	[Ano] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CodOrdem] ASC,
	[CodPessoaFisica] ASC,
	[CodArea] ASC,
	[CodNivelEnsino] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PessoaJuridica]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PessoaJuridica](
	[CodPessoa] [int] NOT NULL,
	[RazaoSocial] [varchar](255) NULL,
	[NomeFantasia] [varchar](100) NOT NULL,
	[Cnpj] [char](15) NULL,
	[Portal] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodPessoa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PessoaOcupacao]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PessoaOcupacao](
	[CodPessoaFisica] [int] NOT NULL,
	[CodOcupacao] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodPessoaFisica] ASC,
	[CodOcupacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Professor]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Professor](
	[CodProfessor] [int] IDENTITY(1,1) NOT NULL,
	[MatrProfessor] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodProfessor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[MatrProfessor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProfessorDisciplina]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProfessorDisciplina](
	[CodProfessor] [int] NOT NULL,
	[CodDisciplina] [int] NOT NULL,
 CONSTRAINT [PK_ProfessorDisciplina] PRIMARY KEY CLUSTERED 
(
	[CodProfessor] ASC,
	[CodDisciplina] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProReitoria]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProReitoria](
	[CodProReitoria] [int] IDENTITY(1,1) NOT NULL,
	[CodInstituicao] [int] NOT NULL,
	[CodPessoaJuridica] [int] NOT NULL,
	[CodColaboradorProReitor] [int] NOT NULL,
	[Sigla] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodProReitoria] ASC,
	[CodInstituicao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Questao]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Questao](
	[CodQuestao] [int] IDENTITY(1,1) NOT NULL,
	[CodProfessor] [int] NOT NULL,
	[CodDificuldade] [int] NOT NULL,
	[CodTipoQuestao] [int] NOT NULL,
	[Enunciado] [text] NULL,
	[Objetivo] [text] NULL,
	[Comentario] [text] NULL,
	[ChaveDeResposta] [text] NULL,
	[DtCadastro] [datetime] NOT NULL DEFAULT (getdate()),
	[DtUltimoUso] [datetime] NULL,
	[FlagArquivo] [bit] NOT NULL CONSTRAINT [DF_Questao_FlagArquivo]  DEFAULT ((0)),
PRIMARY KEY CLUSTERED 
(
	[CodQuestao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[QuestaoAnexo]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[QuestaoAnexo](
	[CodOrdem] [int] NOT NULL,
	[CodTipoAnexo] [int] NOT NULL,
	[CodQuestao] [int] NOT NULL,
	[Anexo] [image] NOT NULL,
	[Legenda] [varchar](250) NULL,
	[Fonte] [varchar](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodOrdem] ASC,
	[CodTipoAnexo] ASC,
	[CodQuestao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[QuestaoTema]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestaoTema](
	[CodQuestao] [int] NOT NULL,
	[CodTema] [int] NOT NULL,
	[CodDisciplina] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodQuestao] ASC,
	[CodTema] ASC,
	[CodDisciplina] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Reitoria]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Reitoria](
	[CodReitoria] [int] IDENTITY(1,1) NOT NULL,
	[CodInstituicao] [int] NOT NULL,
	[CodPessoaJuridica] [int] NOT NULL,
	[CodColaboradorReitor] [int] NOT NULL,
	[Sigla] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodReitoria] ASC,
	[CodInstituicao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Sala]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sala](
	[CodSala] [int] IDENTITY(1,1) NOT NULL,
	[CodInstituicao] [int] NOT NULL,
	[CodCampus] [int] NOT NULL,
	[Descricao] [varchar](50) NOT NULL,
	[Sigla] [varchar](15) NULL,
	[RefLocal] [varchar](255) NULL,
	[Observacao] [varchar](140) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodSala] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Telefone]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Telefone](
	[CodOrdem] [int] NOT NULL,
	[CodPessoa] [int] NOT NULL,
	[CodTipoContato] [int] NOT NULL,
	[CodDDI] [int] NULL,
	[CodDDD] [int] NULL,
	[Numero] [varchar](15) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodOrdem] ASC,
	[CodPessoa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Tema]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tema](
	[CodTema] [int] NOT NULL,
	[CodDisciplina] [int] NOT NULL,
	[Descricao] [varchar](100) NOT NULL,
	[Comentario] [varchar](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodDisciplina] ASC,
	[CodTema] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TipoAnexo]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TipoAnexo](
	[CodTipoAnexo] [int] NOT NULL,
	[Descricao] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodTipoAnexo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TipoAvaliacao]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TipoAvaliacao](
	[CodTipoAvaliacao] [int] NOT NULL,
	[Descricao] [varchar](30) NOT NULL,
	[Sigla] [varchar](4) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodTipoAvaliacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TipoContato]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TipoContato](
	[CodTipoContato] [int] NOT NULL,
	[Descricao] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodTipoContato] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TipoQuestao]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TipoQuestao](
	[CodTipoQuestao] [int] NOT NULL,
	[Descricao] [varchar](15) NOT NULL,
	[Sigla] [varchar](4) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodTipoQuestao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Turma]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Turma](
	[NumTurma] [int] NOT NULL,
	[Periodo] [int] NOT NULL,
	[CodCurso] [int] NOT NULL,
	[CodTurno] [char](1) NOT NULL,
	[Nome] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NumTurma] ASC,
	[Periodo] ASC,
	[CodCurso] ASC,
	[CodTurno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TurmaDiscAluno]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TurmaDiscAluno](
	[AnoLetivo] [int] NOT NULL,
	[SemestreLetivo] [int] NOT NULL,
	[CodDisciplina] [int] NOT NULL,
	[CodCurso] [int] NOT NULL,
	[CodAluno] [int] NOT NULL,
	[Periodo] [int] NOT NULL,
	[NumTurma] [int] NOT NULL,
	[CodTurno] [char](1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AnoLetivo] ASC,
	[SemestreLetivo] ASC,
	[CodDisciplina] ASC,
	[CodCurso] ASC,
	[CodAluno] ASC,
	[Periodo] ASC,
	[NumTurma] ASC,
	[CodTurno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TurmaDiscProfHorario]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TurmaDiscProfHorario](
	[AnoLetivo] [int] NOT NULL,
	[SemestreLetivo] [int] NOT NULL,
	[CodDisciplina] [int] NOT NULL,
	[CodProfessor] [int] NOT NULL,
	[CodDia] [int] NOT NULL,
	[CodTurno] [char](1) NOT NULL,
	[CodHorario] [int] NOT NULL,
	[CodGrupo] [int] NOT NULL,
	[CodCurso] [int] NOT NULL,
	[Periodo] [int] NOT NULL,
	[NumTurma] [int] NOT NULL,
	[CodSala] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AnoLetivo] ASC,
	[SemestreLetivo] ASC,
	[CodDisciplina] ASC,
	[CodProfessor] ASC,
	[CodDia] ASC,
	[CodTurno] ASC,
	[CodHorario] ASC,
	[CodGrupo] ASC,
	[CodCurso] ASC,
	[Periodo] ASC,
	[NumTurma] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Turno]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Turno](
	[CodTurno] [char](1) NOT NULL,
	[Descricao] [varchar](15) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodTurno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Usuario]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Usuario](
	[Matricula] [varchar](20) NOT NULL,
	[CodPessoaFisica] [int] NOT NULL,
	[CodCategoria] [int] NOT NULL,
	[Senha] [char](64) NOT NULL,
	[DtCadastro] [datetime] NOT NULL DEFAULT (getdate()),
PRIMARY KEY CLUSTERED 
(
	[Matricula] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[CodPessoaFisica] ASC,
	[CodCategoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UsuarioAcesso]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UsuarioAcesso](
	[CodOrdem] [int] NOT NULL,
	[Matricula] [varchar](20) NOT NULL,
	[DtAcesso] [datetime] NOT NULL,
	[IpAcesso] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodOrdem] ASC,
	[Matricula] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UsuarioAcessoPagina]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UsuarioAcessoPagina](
	[NumIdentificador] [int] NOT NULL,
	[Matricula] [varchar](20) NOT NULL,
	[CodOrdem] [int] NOT NULL,
	[Titulo] [varchar](200) NOT NULL,
	[DtAbertura] [datetime] NULL,
	[PaginaReferencia] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[NumIdentificador] ASC,
	[Matricula] ASC,
	[CodOrdem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UsuarioOpiniao]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UsuarioOpiniao](
	[CodOrdem] [int] NOT NULL,
	[Matricula] [varchar](20) NOT NULL,
	[Opiniao] [text] NOT NULL,
	[DtEnvio] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[CodOrdem] ASC,
	[Matricula] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Visitante]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Visitante](
	[CodVisitante] [int] IDENTITY(1,1) NOT NULL,
	[MatrVisitante] [varchar](20) NOT NULL,
	[DtValidade] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[CodVisitante] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[MatrVisitante] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[VW_Tema_Com_Questoes]    Script Date: 07/11/2015 19:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[VW_Tema_Com_Questoes] as (select distinct Tema.*
from Tema 
inner join QuestaoTema on QuestaoTema.CodTema = Tema.CodTema and QuestaoTema.CodDisciplina = tema.CodDisciplina
inner join Questao on QuestaoTema.CodQuestao = Questao.CodQuestao 
where GETDATE() < DateAdd(DAY,(select TempoInatividade from Parametro),Questao.DtUltimoUso)
 or Questao.DtUltimoUso is null)
GO
/****** Object:  Index [Alternativa_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [Alternativa_FKIndex1] ON [dbo].[Alternativa]
(
	[CodQuestao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [ALUNO_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [ALUNO_FKIndex1] ON [dbo].[Aluno]
(
	[MatrAluno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Aluno_FKIndex3]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [Aluno_FKIndex3] ON [dbo].[Aluno]
(
	[CodCurso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AvalAcadReposicao_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AvalAcadReposicao_FKIndex1] ON [dbo].[AvalAcadReposicao]
(
	[CodTipoAvaliacao] ASC,
	[Ano] ASC,
	[Semestre] ASC,
	[NumIdentificador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AvalAcadReposicao_FKIndex2]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AvalAcadReposicao_FKIndex2] ON [dbo].[AvalAcadReposicao]
(
	[CodJustificacao] ASC,
	[CodProfessor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AvalAcadReposicao_FKIndex3]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AvalAcadReposicao_FKIndex3] ON [dbo].[AvalAcadReposicao]
(
	[CodSala] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVAL_AUTO_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVAL_AUTO_FKIndex1] ON [dbo].[AvalAuto]
(
	[CodTipoAvaliacao] ASC,
	[Ano] ASC,
	[Semestre] ASC,
	[NumIdentificador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVAL_AUTO_FKIndex2]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVAL_AUTO_FKIndex2] ON [dbo].[AvalAuto]
(
	[CodPessoaFisica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVAL_AUTO_FKIndex3]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVAL_AUTO_FKIndex3] ON [dbo].[AvalAuto]
(
	[CodDificuldade] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVI_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVI_FKIndex1] ON [dbo].[AvalAvi]
(
	[CodTipoAvaliacao] ASC,
	[Ano] ASC,
	[Semestre] ASC,
	[NumIdentificador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVI_FKIndex2]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVI_FKIndex2] ON [dbo].[AvalAvi]
(
	[CodColabCoordenador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVAL_CERT_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVAL_CERT_FKIndex1] ON [dbo].[AvalCertificacao]
(
	[CodTipoAvaliacao] ASC,
	[Ano] ASC,
	[Semestre] ASC,
	[NumIdentificador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVAL_CERT_FKIndex2]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVAL_CERT_FKIndex2] ON [dbo].[AvalCertificacao]
(
	[CodProfessor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVAL_CERT_FKIndex3]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVAL_CERT_FKIndex3] ON [dbo].[AvalCertificacao]
(
	[CodDisciplina] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVAL_CERT_FKIndex4]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVAL_CERT_FKIndex4] ON [dbo].[AvalCertificacao]
(
	[CodSala] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVAL_CERT_PESSOA_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVAL_CERT_PESSOA_FKIndex1] ON [dbo].[AvalCertPessoa]
(
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Semestre] ASC,
	[Ano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVAL_CERT_PESSOA_FKIndex2]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVAL_CERT_PESSOA_FKIndex2] ON [dbo].[AvalCertPessoa]
(
	[CodPessoaFisica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Avaliacao_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [Avaliacao_FKIndex1] ON [dbo].[Avaliacao]
(
	[CodTipoAvaliacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVAL_TEMA_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVAL_TEMA_FKIndex1] ON [dbo].[AvaliacaoTema]
(
	[CodTipoAvaliacao] ASC,
	[Ano] ASC,
	[Semestre] ASC,
	[NumIdentificador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVAL_TEMA_FKIndex2]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVAL_TEMA_FKIndex2] ON [dbo].[AvaliacaoTema]
(
	[CodDisciplina] ASC,
	[CodTema] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PES_AVAL_RESULTADO_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [PES_AVAL_RESULTADO_FKIndex1] ON [dbo].[AvalPessoaResultado]
(
	[CodTipoAvaliacao] ASC,
	[Ano] ASC,
	[Semestre] ASC,
	[NumIdentificador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PES_AVAL_RESULTADO_FKIndex2]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [PES_AVAL_RESULTADO_FKIndex2] ON [dbo].[AvalPessoaResultado]
(
	[CodPessoaFisica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PES_AVAL_QUEST_RESP_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [PES_AVAL_QUEST_RESP_FKIndex1] ON [dbo].[AvalQuesPessoaResposta]
(
	[CodTema] ASC,
	[CodDisciplina] ASC,
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Ano] ASC,
	[Semestre] ASC,
	[CodQuestao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PES_AVAL_QUEST_RESP_FKIndex2]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [PES_AVAL_QUEST_RESP_FKIndex2] ON [dbo].[AvalQuesPessoaResposta]
(
	[CodPessoaFisica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVAL_TEMA_QUESTAO_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVAL_TEMA_QUESTAO_FKIndex1] ON [dbo].[AvalTemaQuestao]
(
	[CodTema] ASC,
	[CodDisciplina] ASC,
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Semestre] ASC,
	[Ano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AvalTemaQuestao_FKIndex2]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AvalTemaQuestao_FKIndex2] ON [dbo].[AvalTemaQuestao]
(
	[CodQuestao] ASC,
	[CodTema] ASC,
	[CodDisciplina] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVI_PUBLICO_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVI_PUBLICO_FKIndex1] ON [dbo].[AviPublico]
(
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Semestre] ASC,
	[Ano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AviPublico_FKIndex2]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AviPublico_FKIndex2] ON [dbo].[AviPublico]
(
	[CodAviTipoPublico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVI_PUBLICO_CAMPUS_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVI_PUBLICO_CAMPUS_FKIndex1] ON [dbo].[AviPublicoCampus]
(
	[CodOrdem] ASC,
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Ano] ASC,
	[Semestre] ASC,
	[CodAviTipoPublico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVI_PUBLICO_CAMPUS_FKIndex2]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVI_PUBLICO_CAMPUS_FKIndex2] ON [dbo].[AviPublicoCampus]
(
	[CodCampus] ASC,
	[CodInstituicao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVI_PUB_CURSO_FKIndex2]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVI_PUB_CURSO_FKIndex2] ON [dbo].[AviPublicoCurso]
(
	[CodCurso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVI_PUBLICO_CURSO_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVI_PUBLICO_CURSO_FKIndex1] ON [dbo].[AviPublicoCurso]
(
	[CodOrdem] ASC,
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Ano] ASC,
	[Semestre] ASC,
	[CodAviTipoPublico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVI_PUBLICO_DIRETORIA_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVI_PUBLICO_DIRETORIA_FKIndex1] ON [dbo].[AviPublicoDiretoria]
(
	[CodOrdem] ASC,
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Ano] ASC,
	[Semestre] ASC,
	[CodAviTipoPublico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVI_PUBLICO_DIRETORIA_FKIndex2]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVI_PUBLICO_DIRETORIA_FKIndex2] ON [dbo].[AviPublicoDiretoria]
(
	[CodDiretoria] ASC,
	[CodInstituicao] ASC,
	[CodCampus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVI_PUB_INSTITUICAO_FKIndex2]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVI_PUB_INSTITUICAO_FKIndex2] ON [dbo].[AviPublicoInstituicao]
(
	[CodInstituicao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVI_PUBLICO_INSTITUICAO_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVI_PUBLICO_INSTITUICAO_FKIndex1] ON [dbo].[AviPublicoInstituicao]
(
	[CodOrdem] ASC,
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Ano] ASC,
	[Semestre] ASC,
	[CodAviTipoPublico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AviPublicoPessoa_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AviPublicoPessoa_FKIndex1] ON [dbo].[AviPublicoPessoa]
(
	[CodOrdem] ASC,
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Ano] ASC,
	[Semestre] ASC,
	[CodAviTipoPublico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AviPublicoPessoa_FKIndex2]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AviPublicoPessoa_FKIndex2] ON [dbo].[AviPublicoPessoa]
(
	[CodPessoaFisica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVI_PUBLICO_PRO_REITORIA_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVI_PUBLICO_PRO_REITORIA_FKIndex1] ON [dbo].[AviPublicoProReitoria]
(
	[CodOrdem] ASC,
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Ano] ASC,
	[Semestre] ASC,
	[CodAviTipoPublico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVI_PUBLICO_PRO_REITORIA_FKIndex2]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVI_PUBLICO_PRO_REITORIA_FKIndex2] ON [dbo].[AviPublicoProReitoria]
(
	[CodProReitoria] ASC,
	[CodInstituicao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVI_PUBLICO_REITORIA_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVI_PUBLICO_REITORIA_FKIndex1] ON [dbo].[AviPublicoReitoria]
(
	[CodOrdem] ASC,
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Ano] ASC,
	[Semestre] ASC,
	[CodAviTipoPublico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVI_PUBLICO_REITORIA_FKIndex2]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVI_PUBLICO_REITORIA_FKIndex2] ON [dbo].[AviPublicoReitoria]
(
	[CodReitoria] ASC,
	[CodInstituicao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVI_PUBLICO_TURMA_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVI_PUBLICO_TURMA_FKIndex1] ON [dbo].[AviPublicoTurma]
(
	[CodOrdem] ASC,
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Ano] ASC,
	[Semestre] ASC,
	[CodAviTipoPublico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [AVI_PUBLICO_TURMA_FKIndex2]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVI_PUBLICO_TURMA_FKIndex2] ON [dbo].[AviPublicoTurma]
(
	[NumTurma] ASC,
	[Periodo] ASC,
	[CodCurso] ASC,
	[CodTurno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVI_QUESTAO_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVI_QUESTAO_FKIndex1] ON [dbo].[AviQuestao]
(
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Semestre] ASC,
	[Ano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AviQuestao_FKIndex2]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AviQuestao_FKIndex2] ON [dbo].[AviQuestao]
(
	[CodAviModulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AviQuestao_FKIndex3]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AviQuestao_FKIndex3] ON [dbo].[AviQuestao]
(
	[CodAviCategoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AviQuestao_FKIndex4]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AviQuestao_FKIndex4] ON [dbo].[AviQuestao]
(
	[CodAviIndicador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVI_QUESTAO_ALTERNATIVA_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVI_QUESTAO_ALTERNATIVA_FKIndex1] ON [dbo].[AviQuestaoAlternativa]
(
	[CodOrdem] ASC,
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Ano] ASC,
	[Semestre] ASC,
	[CodAviIndicador] ASC,
	[CodAviCategoria] ASC,
	[CodAviModulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [AVI_PES_QUESTAO_RESP_FKIndex2]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [AVI_PES_QUESTAO_RESP_FKIndex2] ON [dbo].[AviQuestaoPessoaResposta]
(
	[CodPessoaFisica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PESSOA_AVI_QUESTAO_RESP_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [PESSOA_AVI_QUESTAO_RESP_FKIndex1] ON [dbo].[AviQuestaoPessoaResposta]
(
	[CodOrdem] ASC,
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Ano] ASC,
	[Semestre] ASC,
	[CodAviIndicador] ASC,
	[CodAviCategoria] ASC,
	[CodAviModulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [BAIRRO_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [BAIRRO_FKIndex1] ON [dbo].[Bairro]
(
	[CodPais] ASC,
	[CodEstado] ASC,
	[CodMunicipio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Campus_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [Campus_FKIndex1] ON [dbo].[Campus]
(
	[CodPessoaJuridica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Campus_FKIndex2]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [Campus_FKIndex2] ON [dbo].[Campus]
(
	[CodColaboradorDiretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Campus_FKIndex3]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [Campus_FKIndex3] ON [dbo].[Campus]
(
	[CodInstituicao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [COLABORADOR_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [COLABORADOR_FKIndex1] ON [dbo].[Colaborador]
(
	[MatrColaborador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [CURSO_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [CURSO_FKIndex1] ON [dbo].[Curso]
(
	[CodDiretoria] ASC,
	[CodInstituicao] ASC,
	[CodCampus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Curso_FKIndex2]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [Curso_FKIndex2] ON [dbo].[Curso]
(
	[CodNivelEnsino] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [DIRETORIA_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [DIRETORIA_FKIndex1] ON [dbo].[Diretoria]
(
	[CodCampus] ASC,
	[CodInstituicao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Diretoria_FKIndex2]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [Diretoria_FKIndex2] ON [dbo].[Diretoria]
(
	[CodPessoaJuridica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Diretoria_FKIndex3]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [Diretoria_FKIndex3] ON [dbo].[Diretoria]
(
	[CodColaboradorDiretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Email_FKIndex1]    Script Date: 07/11/2015 19:30:34 ******/
CREATE NONCLUSTERED INDEX [Email_FKIndex1] ON [dbo].[Email]
(
	[CodTipoContato] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Email_FKIndex2]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [Email_FKIndex2] ON [dbo].[Email]
(
	[CodPessoa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ENDERECO_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [ENDERECO_FKIndex1] ON [dbo].[Endereco]
(
	[CodBairro] ASC,
	[CodEstado] ASC,
	[CodPais] ASC,
	[CodMunicipio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Endereco_FKIndex2]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [Endereco_FKIndex2] ON [dbo].[Endereco]
(
	[CodPessoa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Estado_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [Estado_FKIndex1] ON [dbo].[Estado]
(
	[CodPais] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [Horario_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [Horario_FKIndex1] ON [dbo].[Horario]
(
	[CodTurno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Instituicao_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [Instituicao_FKIndex1] ON [dbo].[Instituicao]
(
	[CodPessoaJuridica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [JUSTIFICACAO_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [JUSTIFICACAO_FKIndex1] ON [dbo].[Justificacao]
(
	[CodPessoaFisica] ASC,
	[NumIdentificador] ASC,
	[CodTipoAvaliacao] ASC,
	[Semestre] ASC,
	[Ano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [JUSTIFICACAO_FKIndex2]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [JUSTIFICACAO_FKIndex2] ON [dbo].[Justificacao]
(
	[CodProfessor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [MatrizCurricular_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [MatrizCurricular_FKIndex1] ON [dbo].[MatrizCurricular]
(
	[CodCurso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [MatrizCurricular_has_Disciplina_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [MatrizCurricular_has_Disciplina_FKIndex1] ON [dbo].[MatrizCurricularDisciplina]
(
	[CodMatriz] ASC,
	[CodCurso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [MatrizCurricular_has_Disciplina_FKIndex2]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [MatrizCurricular_has_Disciplina_FKIndex2] ON [dbo].[MatrizCurricularDisciplina]
(
	[CodDisciplina] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Municipio_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [Municipio_FKIndex1] ON [dbo].[Municipio]
(
	[CodEstado] ASC,
	[CodPais] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PessoaCategoria_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [PessoaCategoria_FKIndex1] ON [dbo].[PessoaCategoria]
(
	[CodPessoaFisica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PessoaCategoria_FKIndex2]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [PessoaCategoria_FKIndex2] ON [dbo].[PessoaCategoria]
(
	[CodCategoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PessoaFisica_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [PessoaFisica_FKIndex1] ON [dbo].[PessoaFisica]
(
	[CodPessoa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PessoaFormacao_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [PessoaFormacao_FKIndex1] ON [dbo].[PessoaFormacao]
(
	[CodNivelEnsino] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PessoaFormacao_FKIndex2]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [PessoaFormacao_FKIndex2] ON [dbo].[PessoaFormacao]
(
	[CodArea] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PessoaFormacao_FKIndex3]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [PessoaFormacao_FKIndex3] ON [dbo].[PessoaFormacao]
(
	[CodPessoaFisica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PessoaJuridica_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [PessoaJuridica_FKIndex1] ON [dbo].[PessoaJuridica]
(
	[CodPessoa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PessoaOcupacao_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [PessoaOcupacao_FKIndex1] ON [dbo].[PessoaOcupacao]
(
	[CodPessoaFisica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PessoaOcupacao_FKIndex2]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [PessoaOcupacao_FKIndex2] ON [dbo].[PessoaOcupacao]
(
	[CodOcupacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [PROFESSOR_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [PROFESSOR_FKIndex1] ON [dbo].[Professor]
(
	[MatrProfessor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ProReitoria_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [ProReitoria_FKIndex1] ON [dbo].[ProReitoria]
(
	[CodPessoaJuridica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ProReitoria_FKIndex2]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [ProReitoria_FKIndex2] ON [dbo].[ProReitoria]
(
	[CodColaboradorProReitor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ProReitoria_FKIndex3]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [ProReitoria_FKIndex3] ON [dbo].[ProReitoria]
(
	[CodInstituicao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Questao_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [Questao_FKIndex1] ON [dbo].[Questao]
(
	[CodDificuldade] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Questao_FKIndex2]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [Questao_FKIndex2] ON [dbo].[Questao]
(
	[CodTipoQuestao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Questao_FKIndex3]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [Questao_FKIndex3] ON [dbo].[Questao]
(
	[CodProfessor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [QuestaoAnexo_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [QuestaoAnexo_FKIndex1] ON [dbo].[QuestaoAnexo]
(
	[CodTipoAnexo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [QuestaoAnexo_FKIndex2]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [QuestaoAnexo_FKIndex2] ON [dbo].[QuestaoAnexo]
(
	[CodQuestao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [QUESTAO_TEMA_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [QUESTAO_TEMA_FKIndex1] ON [dbo].[QuestaoTema]
(
	[CodDisciplina] ASC,
	[CodTema] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [QuestaoTema_FKIndex2]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [QuestaoTema_FKIndex2] ON [dbo].[QuestaoTema]
(
	[CodQuestao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Reitoria_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [Reitoria_FKIndex1] ON [dbo].[Reitoria]
(
	[CodInstituicao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Reitoria_FKIndex2]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [Reitoria_FKIndex2] ON [dbo].[Reitoria]
(
	[CodPessoaJuridica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Reitoria_FKIndex3]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [Reitoria_FKIndex3] ON [dbo].[Reitoria]
(
	[CodColaboradorReitor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Sala_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [Sala_FKIndex1] ON [dbo].[Sala]
(
	[CodCampus] ASC,
	[CodInstituicao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Telefone_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [Telefone_FKIndex1] ON [dbo].[Telefone]
(
	[CodTipoContato] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Telefone_FKIndex2]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [Telefone_FKIndex2] ON [dbo].[Telefone]
(
	[CodPessoa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Tema_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [Tema_FKIndex1] ON [dbo].[Tema]
(
	[CodDisciplina] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Turma_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [Turma_FKIndex1] ON [dbo].[Turma]
(
	[CodCurso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [Turma_FKIndex2]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [Turma_FKIndex2] ON [dbo].[Turma]
(
	[CodTurno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [ALUNO_DISC_TURMA_FKIndex2]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [ALUNO_DISC_TURMA_FKIndex2] ON [dbo].[TurmaDiscAluno]
(
	[NumTurma] ASC,
	[Periodo] ASC,
	[CodCurso] ASC,
	[CodTurno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ALUNO_DISC_TURMA_FKIndex3]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [ALUNO_DISC_TURMA_FKIndex3] ON [dbo].[TurmaDiscAluno]
(
	[CodDisciplina] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [TurmaDiscAluno_FKIndex3]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [TurmaDiscAluno_FKIndex3] ON [dbo].[TurmaDiscAluno]
(
	[CodAluno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [PROF_DISC_TURMA_HORARIO_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [PROF_DISC_TURMA_HORARIO_FKIndex1] ON [dbo].[TurmaDiscProfHorario]
(
	[NumTurma] ASC,
	[Periodo] ASC,
	[CodCurso] ASC,
	[CodTurno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [PROF_DISC_TURMA_HORARIO_FKIndex2]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [PROF_DISC_TURMA_HORARIO_FKIndex2] ON [dbo].[TurmaDiscProfHorario]
(
	[CodGrupo] ASC,
	[CodHorario] ASC,
	[CodTurno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PROF_DISC_TURMA_HORARIO_FKIndex3]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [PROF_DISC_TURMA_HORARIO_FKIndex3] ON [dbo].[TurmaDiscProfHorario]
(
	[CodProfessor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PROF_DISC_TURMA_HORARIO_FKIndex4]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [PROF_DISC_TURMA_HORARIO_FKIndex4] ON [dbo].[TurmaDiscProfHorario]
(
	[CodDisciplina] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PROF_DISC_TURMA_HORARIO_FKIndex5]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [PROF_DISC_TURMA_HORARIO_FKIndex5] ON [dbo].[TurmaDiscProfHorario]
(
	[CodDia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [PROF_DISC_TURMA_HORARIO_FKIndex6]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [PROF_DISC_TURMA_HORARIO_FKIndex6] ON [dbo].[TurmaDiscProfHorario]
(
	[CodSala] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IFK_Rel_CategoriaUsuario]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [IFK_Rel_CategoriaUsuario] ON [dbo].[Usuario]
(
	[CodCategoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IFK_Rel_PessoaFisicaUsuario]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [IFK_Rel_PessoaFisicaUsuario] ON [dbo].[Usuario]
(
	[CodPessoaFisica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UsuarioAcesso_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [UsuarioAcesso_FKIndex1] ON [dbo].[UsuarioAcesso]
(
	[Matricula] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UsuarioAcessoPagina_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [UsuarioAcessoPagina_FKIndex1] ON [dbo].[UsuarioAcessoPagina]
(
	[CodOrdem] ASC,
	[Matricula] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UsuarioOpiniao_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [UsuarioOpiniao_FKIndex1] ON [dbo].[UsuarioOpiniao]
(
	[Matricula] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [VISITANTE_FKIndex1]    Script Date: 07/11/2015 19:30:35 ******/
CREATE NONCLUSTERED INDEX [VISITANTE_FKIndex1] ON [dbo].[Visitante]
(
	[MatrVisitante] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AvalAcadReposicao] ADD  DEFAULT ((10)) FOR [Valor]
GO
ALTER TABLE [dbo].[AviQuestao] ADD  DEFAULT ((0)) FOR [FlagDiscursiva]
GO
ALTER TABLE [dbo].[AviQuestaoPessoaResposta] ADD  DEFAULT ((1)) FOR [CodRespostaOrdem]
GO
ALTER TABLE [dbo].[AviQuestaoPessoaResposta] ADD  DEFAULT (getdate()) FOR [RespData]
GO
ALTER TABLE [dbo].[Telefone] ADD  DEFAULT ((55)) FOR [CodDDI]
GO
ALTER TABLE [dbo].[Telefone] ADD  DEFAULT ((84)) FOR [CodDDD]
GO
ALTER TABLE [dbo].[UsuarioAcesso] ADD  DEFAULT (getdate()) FOR [DtAcesso]
GO
ALTER TABLE [dbo].[UsuarioAcessoPagina] ADD  DEFAULT (getdate()) FOR [DtAbertura]
GO
ALTER TABLE [dbo].[UsuarioOpiniao] ADD  DEFAULT (getdate()) FOR [DtEnvio]
GO
ALTER TABLE [dbo].[Alternativa]  WITH CHECK ADD FOREIGN KEY([CodQuestao])
REFERENCES [dbo].[Questao] ([CodQuestao])
GO
ALTER TABLE [dbo].[Aluno]  WITH CHECK ADD FOREIGN KEY([CodCurso])
REFERENCES [dbo].[Curso] ([CodCurso])
GO
ALTER TABLE [dbo].[Aluno]  WITH CHECK ADD FOREIGN KEY([MatrAluno])
REFERENCES [dbo].[Usuario] ([Matricula])
GO
ALTER TABLE [dbo].[AvalAcademica]  WITH CHECK ADD FOREIGN KEY([CodDisciplina])
REFERENCES [dbo].[Disciplina] ([CodDisciplina])
GO
ALTER TABLE [dbo].[AvalAcademica]  WITH CHECK ADD FOREIGN KEY([CodProfessor])
REFERENCES [dbo].[Professor] ([CodProfessor])
GO
ALTER TABLE [dbo].[AvalAcademica]  WITH CHECK ADD FOREIGN KEY([CodSala])
REFERENCES [dbo].[Sala] ([CodSala])
GO
ALTER TABLE [dbo].[AvalAcademica]  WITH CHECK ADD FOREIGN KEY([CodTipoAvaliacao], [Ano], [Semestre], [NumIdentificador])
REFERENCES [dbo].[Avaliacao] ([CodTipoAvaliacao], [Ano], [Semestre], [NumIdentificador])
GO
ALTER TABLE [dbo].[AvalAcademica]  WITH CHECK ADD FOREIGN KEY([NumTurma], [Periodo], [CodCurso], [CodTurno])
REFERENCES [dbo].[Turma] ([NumTurma], [Periodo], [CodCurso], [CodTurno])
GO
ALTER TABLE [dbo].[AvalAcadReposicao]  WITH CHECK ADD FOREIGN KEY([CodSala])
REFERENCES [dbo].[Sala] ([CodSala])
GO
ALTER TABLE [dbo].[AvalAcadReposicao]  WITH CHECK ADD FOREIGN KEY([CodTipoAvaliacao], [Ano], [Semestre], [NumIdentificador])
REFERENCES [dbo].[Avaliacao] ([CodTipoAvaliacao], [Ano], [Semestre], [NumIdentificador])
GO
ALTER TABLE [dbo].[AvalAcadReposicao]  WITH CHECK ADD FOREIGN KEY([CodJustificacao], [CodProfessor])
REFERENCES [dbo].[Justificacao] ([CodJustificacao], [CodProfessor])
GO
ALTER TABLE [dbo].[AvalAuto]  WITH CHECK ADD FOREIGN KEY([CodTipoAvaliacao], [Ano], [Semestre], [NumIdentificador])
REFERENCES [dbo].[Avaliacao] ([CodTipoAvaliacao], [Ano], [Semestre], [NumIdentificador])
GO
ALTER TABLE [dbo].[AvalAuto]  WITH CHECK ADD FOREIGN KEY([CodDificuldade])
REFERENCES [dbo].[Dificuldade] ([CodDificuldade])
GO
ALTER TABLE [dbo].[AvalAuto]  WITH CHECK ADD FOREIGN KEY([CodPessoaFisica])
REFERENCES [dbo].[PessoaFisica] ([CodPessoa])
GO
ALTER TABLE [dbo].[AvalAvi]  WITH CHECK ADD FOREIGN KEY([CodTipoAvaliacao], [Ano], [Semestre], [NumIdentificador])
REFERENCES [dbo].[Avaliacao] ([CodTipoAvaliacao], [Ano], [Semestre], [NumIdentificador])
GO
ALTER TABLE [dbo].[AvalAvi]  WITH CHECK ADD FOREIGN KEY([CodColabCoordenador])
REFERENCES [dbo].[Colaborador] ([CodColaborador])
GO
ALTER TABLE [dbo].[AvalCertificacao]  WITH CHECK ADD FOREIGN KEY([CodDisciplina])
REFERENCES [dbo].[Disciplina] ([CodDisciplina])
GO
ALTER TABLE [dbo].[AvalCertificacao]  WITH CHECK ADD FOREIGN KEY([CodProfessor])
REFERENCES [dbo].[Professor] ([CodProfessor])
GO
ALTER TABLE [dbo].[AvalCertificacao]  WITH CHECK ADD FOREIGN KEY([CodSala])
REFERENCES [dbo].[Sala] ([CodSala])
GO
ALTER TABLE [dbo].[AvalCertificacao]  WITH CHECK ADD FOREIGN KEY([CodTipoAvaliacao], [Ano], [Semestre], [NumIdentificador])
REFERENCES [dbo].[Avaliacao] ([CodTipoAvaliacao], [Ano], [Semestre], [NumIdentificador])
GO
ALTER TABLE [dbo].[AvalCertPessoa]  WITH CHECK ADD FOREIGN KEY([CodPessoaFisica])
REFERENCES [dbo].[PessoaFisica] ([CodPessoa])
GO
ALTER TABLE [dbo].[AvalCertPessoa]  WITH CHECK ADD FOREIGN KEY([NumIdentificador], [CodTipoAvaliacao], [Semestre], [Ano])
REFERENCES [dbo].[AvalCertificacao] ([NumIdentificador], [CodTipoAvaliacao], [Semestre], [Ano])
GO
ALTER TABLE [dbo].[Avaliacao]  WITH CHECK ADD FOREIGN KEY([CodTipoAvaliacao])
REFERENCES [dbo].[TipoAvaliacao] ([CodTipoAvaliacao])
GO
ALTER TABLE [dbo].[AvaliacaoTema]  WITH CHECK ADD FOREIGN KEY([CodTipoAvaliacao], [Ano], [Semestre], [NumIdentificador])
REFERENCES [dbo].[Avaliacao] ([CodTipoAvaliacao], [Ano], [Semestre], [NumIdentificador])
GO
ALTER TABLE [dbo].[AvaliacaoTema]  WITH CHECK ADD FOREIGN KEY([CodDisciplina], [CodTema])
REFERENCES [dbo].[Tema] ([CodDisciplina], [CodTema])
GO
ALTER TABLE [dbo].[AvalPessoaResultado]  WITH CHECK ADD FOREIGN KEY([CodPessoaFisica])
REFERENCES [dbo].[PessoaFisica] ([CodPessoa])
GO
ALTER TABLE [dbo].[AvalPessoaResultado]  WITH CHECK ADD FOREIGN KEY([CodTipoAvaliacao], [Ano], [Semestre], [NumIdentificador])
REFERENCES [dbo].[Avaliacao] ([CodTipoAvaliacao], [Ano], [Semestre], [NumIdentificador])
GO
ALTER TABLE [dbo].[AvalQuesPessoaResposta]  WITH CHECK ADD FOREIGN KEY([CodPessoaFisica])
REFERENCES [dbo].[PessoaFisica] ([CodPessoa])
GO
ALTER TABLE [dbo].[AvalQuesPessoaResposta]  WITH CHECK ADD FOREIGN KEY([CodTema], [CodDisciplina], [NumIdentificador], [CodTipoAvaliacao], [Ano], [Semestre], [CodQuestao])
REFERENCES [dbo].[AvalTemaQuestao] ([CodTema], [CodDisciplina], [NumIdentificador], [CodTipoAvaliacao], [Ano], [Semestre], [CodQuestao])
GO
ALTER TABLE [dbo].[AvalTemaQuestao]  WITH CHECK ADD FOREIGN KEY([CodTema], [CodDisciplina], [NumIdentificador], [CodTipoAvaliacao], [Semestre], [Ano])
REFERENCES [dbo].[AvaliacaoTema] ([CodTema], [CodDisciplina], [NumIdentificador], [CodTipoAvaliacao], [Semestre], [Ano])
GO
ALTER TABLE [dbo].[AvalTemaQuestao]  WITH CHECK ADD FOREIGN KEY([CodQuestao], [CodTema], [CodDisciplina])
REFERENCES [dbo].[QuestaoTema] ([CodQuestao], [CodTema], [CodDisciplina])
GO
ALTER TABLE [dbo].[AviPublico]  WITH CHECK ADD FOREIGN KEY([CodAviTipoPublico])
REFERENCES [dbo].[AviTipoPublico] ([CodAviTipoPublico])
GO
ALTER TABLE [dbo].[AviPublico]  WITH CHECK ADD FOREIGN KEY([NumIdentificador], [CodTipoAvaliacao], [Semestre], [Ano])
REFERENCES [dbo].[AvalAvi] ([NumIdentificador], [CodTipoAvaliacao], [Semestre], [Ano])
GO
ALTER TABLE [dbo].[AviPublicoCampus]  WITH CHECK ADD FOREIGN KEY([CodOrdem], [NumIdentificador], [CodTipoAvaliacao], [Ano], [Semestre], [CodAviTipoPublico])
REFERENCES [dbo].[AviPublico] ([CodOrdem], [NumIdentificador], [CodTipoAvaliacao], [Ano], [Semestre], [CodAviTipoPublico])
GO
ALTER TABLE [dbo].[AviPublicoCampus]  WITH CHECK ADD FOREIGN KEY([CodCampus], [CodInstituicao])
REFERENCES [dbo].[Campus] ([CodCampus], [CodInstituicao])
GO
ALTER TABLE [dbo].[AviPublicoCurso]  WITH CHECK ADD FOREIGN KEY([CodCurso])
REFERENCES [dbo].[Curso] ([CodCurso])
GO
ALTER TABLE [dbo].[AviPublicoCurso]  WITH CHECK ADD FOREIGN KEY([CodOrdem], [NumIdentificador], [CodTipoAvaliacao], [Ano], [Semestre], [CodAviTipoPublico])
REFERENCES [dbo].[AviPublico] ([CodOrdem], [NumIdentificador], [CodTipoAvaliacao], [Ano], [Semestre], [CodAviTipoPublico])
GO
ALTER TABLE [dbo].[AviPublicoDiretoria]  WITH CHECK ADD FOREIGN KEY([CodOrdem], [NumIdentificador], [CodTipoAvaliacao], [Ano], [Semestre], [CodAviTipoPublico])
REFERENCES [dbo].[AviPublico] ([CodOrdem], [NumIdentificador], [CodTipoAvaliacao], [Ano], [Semestre], [CodAviTipoPublico])
GO
ALTER TABLE [dbo].[AviPublicoDiretoria]  WITH CHECK ADD FOREIGN KEY([CodDiretoria], [CodInstituicao], [CodCampus])
REFERENCES [dbo].[Diretoria] ([CodDiretoria], [CodInstituicao], [CodCampus])
GO
ALTER TABLE [dbo].[AviPublicoInstituicao]  WITH CHECK ADD FOREIGN KEY([CodInstituicao])
REFERENCES [dbo].[Instituicao] ([CodInstituicao])
GO
ALTER TABLE [dbo].[AviPublicoInstituicao]  WITH CHECK ADD FOREIGN KEY([CodOrdem], [NumIdentificador], [CodTipoAvaliacao], [Ano], [Semestre], [CodAviTipoPublico])
REFERENCES [dbo].[AviPublico] ([CodOrdem], [NumIdentificador], [CodTipoAvaliacao], [Ano], [Semestre], [CodAviTipoPublico])
GO
ALTER TABLE [dbo].[AviPublicoPessoa]  WITH CHECK ADD FOREIGN KEY([CodPessoaFisica])
REFERENCES [dbo].[PessoaFisica] ([CodPessoa])
GO
ALTER TABLE [dbo].[AviPublicoPessoa]  WITH CHECK ADD FOREIGN KEY([CodOrdem], [NumIdentificador], [CodTipoAvaliacao], [Ano], [Semestre], [CodAviTipoPublico])
REFERENCES [dbo].[AviPublico] ([CodOrdem], [NumIdentificador], [CodTipoAvaliacao], [Ano], [Semestre], [CodAviTipoPublico])
GO
ALTER TABLE [dbo].[AviPublicoProReitoria]  WITH CHECK ADD FOREIGN KEY([CodOrdem], [NumIdentificador], [CodTipoAvaliacao], [Ano], [Semestre], [CodAviTipoPublico])
REFERENCES [dbo].[AviPublico] ([CodOrdem], [NumIdentificador], [CodTipoAvaliacao], [Ano], [Semestre], [CodAviTipoPublico])
GO
ALTER TABLE [dbo].[AviPublicoProReitoria]  WITH CHECK ADD FOREIGN KEY([CodProReitoria], [CodInstituicao])
REFERENCES [dbo].[ProReitoria] ([CodProReitoria], [CodInstituicao])
GO
ALTER TABLE [dbo].[AviPublicoReitoria]  WITH CHECK ADD FOREIGN KEY([CodOrdem], [NumIdentificador], [CodTipoAvaliacao], [Ano], [Semestre], [CodAviTipoPublico])
REFERENCES [dbo].[AviPublico] ([CodOrdem], [NumIdentificador], [CodTipoAvaliacao], [Ano], [Semestre], [CodAviTipoPublico])
GO
ALTER TABLE [dbo].[AviPublicoReitoria]  WITH CHECK ADD FOREIGN KEY([CodReitoria], [CodInstituicao])
REFERENCES [dbo].[Reitoria] ([CodReitoria], [CodInstituicao])
GO
ALTER TABLE [dbo].[AviPublicoTurma]  WITH CHECK ADD FOREIGN KEY([CodOrdem], [NumIdentificador], [CodTipoAvaliacao], [Ano], [Semestre], [CodAviTipoPublico])
REFERENCES [dbo].[AviPublico] ([CodOrdem], [NumIdentificador], [CodTipoAvaliacao], [Ano], [Semestre], [CodAviTipoPublico])
GO
ALTER TABLE [dbo].[AviPublicoTurma]  WITH CHECK ADD FOREIGN KEY([NumTurma], [Periodo], [CodCurso], [CodTurno])
REFERENCES [dbo].[Turma] ([NumTurma], [Periodo], [CodCurso], [CodTurno])
GO
ALTER TABLE [dbo].[AviQuestao]  WITH CHECK ADD FOREIGN KEY([CodAviModulo])
REFERENCES [dbo].[AviModulo] ([CodAviModulo])
GO
ALTER TABLE [dbo].[AviQuestao]  WITH CHECK ADD FOREIGN KEY([CodAviCategoria])
REFERENCES [dbo].[AviCategoria] ([CodAviCategoria])
GO
ALTER TABLE [dbo].[AviQuestao]  WITH CHECK ADD FOREIGN KEY([CodAviIndicador])
REFERENCES [dbo].[AviIndicador] ([CodAviIndicador])
GO
ALTER TABLE [dbo].[AviQuestao]  WITH CHECK ADD FOREIGN KEY([NumIdentificador], [CodTipoAvaliacao], [Semestre], [Ano])
REFERENCES [dbo].[AvalAvi] ([NumIdentificador], [CodTipoAvaliacao], [Semestre], [Ano])
GO
ALTER TABLE [dbo].[AviQuestaoAlternativa]  WITH CHECK ADD FOREIGN KEY([CodOrdem], [NumIdentificador], [CodTipoAvaliacao], [Ano], [Semestre], [CodAviIndicador], [CodAviCategoria], [CodAviModulo])
REFERENCES [dbo].[AviQuestao] ([CodOrdem], [NumIdentificador], [CodTipoAvaliacao], [Ano], [Semestre], [CodAviIndicador], [CodAviCategoria], [CodAviModulo])
GO
ALTER TABLE [dbo].[AviQuestaoPessoaResposta]  WITH CHECK ADD FOREIGN KEY([CodPessoaFisica])
REFERENCES [dbo].[PessoaFisica] ([CodPessoa])
GO
ALTER TABLE [dbo].[AviQuestaoPessoaResposta]  WITH CHECK ADD FOREIGN KEY([CodOrdem], [NumIdentificador], [CodTipoAvaliacao], [Ano], [Semestre], [CodAviIndicador], [CodAviCategoria], [CodAviModulo])
REFERENCES [dbo].[AviQuestao] ([CodOrdem], [NumIdentificador], [CodTipoAvaliacao], [Ano], [Semestre], [CodAviIndicador], [CodAviCategoria], [CodAviModulo])
GO
ALTER TABLE [dbo].[Bairro]  WITH CHECK ADD FOREIGN KEY([CodPais], [CodEstado], [CodMunicipio])
REFERENCES [dbo].[Municipio] ([CodPais], [CodEstado], [CodMunicipio])
GO
ALTER TABLE [dbo].[Campus]  WITH CHECK ADD FOREIGN KEY([CodColaboradorDiretor])
REFERENCES [dbo].[Colaborador] ([CodColaborador])
GO
ALTER TABLE [dbo].[Campus]  WITH CHECK ADD FOREIGN KEY([CodInstituicao])
REFERENCES [dbo].[Instituicao] ([CodInstituicao])
GO
ALTER TABLE [dbo].[Campus]  WITH CHECK ADD FOREIGN KEY([CodPessoaJuridica])
REFERENCES [dbo].[PessoaJuridica] ([CodPessoa])
GO
ALTER TABLE [dbo].[Colaborador]  WITH CHECK ADD FOREIGN KEY([MatrColaborador])
REFERENCES [dbo].[Usuario] ([Matricula])
GO
ALTER TABLE [dbo].[Curso]  WITH CHECK ADD FOREIGN KEY([CodDiretoria], [CodInstituicao], [CodCampus])
REFERENCES [dbo].[Diretoria] ([CodDiretoria], [CodInstituicao], [CodCampus])
GO
ALTER TABLE [dbo].[Curso]  WITH CHECK ADD FOREIGN KEY([CodColabCoordenador])
REFERENCES [dbo].[Colaborador] ([CodColaborador])
GO
ALTER TABLE [dbo].[Curso]  WITH CHECK ADD FOREIGN KEY([CodNivelEnsino])
REFERENCES [dbo].[NivelEnsino] ([CodNivelEnsino])
GO
ALTER TABLE [dbo].[Diretoria]  WITH CHECK ADD FOREIGN KEY([CodCampus], [CodInstituicao])
REFERENCES [dbo].[Campus] ([CodCampus], [CodInstituicao])
GO
ALTER TABLE [dbo].[Diretoria]  WITH CHECK ADD FOREIGN KEY([CodColaboradorDiretor])
REFERENCES [dbo].[Colaborador] ([CodColaborador])
GO
ALTER TABLE [dbo].[Diretoria]  WITH CHECK ADD FOREIGN KEY([CodPessoaJuridica])
REFERENCES [dbo].[PessoaJuridica] ([CodPessoa])
GO
ALTER TABLE [dbo].[Email]  WITH CHECK ADD FOREIGN KEY([CodPessoa])
REFERENCES [dbo].[Pessoa] ([CodPessoa])
GO
ALTER TABLE [dbo].[Email]  WITH CHECK ADD FOREIGN KEY([CodTipoContato])
REFERENCES [dbo].[TipoContato] ([CodTipoContato])
GO
ALTER TABLE [dbo].[Endereco]  WITH CHECK ADD FOREIGN KEY([CodBairro], [CodEstado], [CodPais], [CodMunicipio])
REFERENCES [dbo].[Bairro] ([CodBairro], [CodEstado], [CodPais], [CodMunicipio])
GO
ALTER TABLE [dbo].[Endereco]  WITH CHECK ADD FOREIGN KEY([CodPessoa])
REFERENCES [dbo].[Pessoa] ([CodPessoa])
GO
ALTER TABLE [dbo].[Estado]  WITH CHECK ADD FOREIGN KEY([CodPais])
REFERENCES [dbo].[Pais] ([CodPais])
GO
ALTER TABLE [dbo].[Horario]  WITH CHECK ADD FOREIGN KEY([CodTurno])
REFERENCES [dbo].[Turno] ([CodTurno])
GO
ALTER TABLE [dbo].[Instituicao]  WITH CHECK ADD FOREIGN KEY([CodPessoaJuridica])
REFERENCES [dbo].[PessoaJuridica] ([CodPessoa])
GO
ALTER TABLE [dbo].[Justificacao]  WITH CHECK ADD FOREIGN KEY([CodProfessor])
REFERENCES [dbo].[Professor] ([CodProfessor])
GO
ALTER TABLE [dbo].[Justificacao]  WITH CHECK ADD FOREIGN KEY([CodPessoaFisica], [NumIdentificador], [CodTipoAvaliacao], [Semestre], [Ano])
REFERENCES [dbo].[AvalPessoaResultado] ([CodPessoaFisica], [NumIdentificador], [CodTipoAvaliacao], [Semestre], [Ano])
GO
ALTER TABLE [dbo].[MatrizCurricular]  WITH CHECK ADD FOREIGN KEY([CodCurso])
REFERENCES [dbo].[Curso] ([CodCurso])
GO
ALTER TABLE [dbo].[MatrizCurricularDisciplina]  WITH CHECK ADD FOREIGN KEY([CodDisciplina])
REFERENCES [dbo].[Disciplina] ([CodDisciplina])
GO
ALTER TABLE [dbo].[MatrizCurricularDisciplina]  WITH CHECK ADD FOREIGN KEY([CodMatriz], [CodCurso])
REFERENCES [dbo].[MatrizCurricular] ([CodMatriz], [CodCurso])
GO
ALTER TABLE [dbo].[Municipio]  WITH CHECK ADD FOREIGN KEY([CodPais], [CodEstado])
REFERENCES [dbo].[Estado] ([CodPais], [CodEstado])
GO
ALTER TABLE [dbo].[PessoaCategoria]  WITH CHECK ADD FOREIGN KEY([CodCategoria])
REFERENCES [dbo].[Categoria] ([CodCategoria])
GO
ALTER TABLE [dbo].[PessoaCategoria]  WITH CHECK ADD FOREIGN KEY([CodPessoaFisica])
REFERENCES [dbo].[PessoaFisica] ([CodPessoa])
GO
ALTER TABLE [dbo].[PessoaFisica]  WITH CHECK ADD FOREIGN KEY([CodPessoa])
REFERENCES [dbo].[Pessoa] ([CodPessoa])
GO
ALTER TABLE [dbo].[PessoaFormacao]  WITH CHECK ADD FOREIGN KEY([CodArea])
REFERENCES [dbo].[Area] ([CodArea])
GO
ALTER TABLE [dbo].[PessoaFormacao]  WITH CHECK ADD FOREIGN KEY([CodNivelEnsino])
REFERENCES [dbo].[NivelEnsino] ([CodNivelEnsino])
GO
ALTER TABLE [dbo].[PessoaFormacao]  WITH CHECK ADD FOREIGN KEY([CodPessoaFisica])
REFERENCES [dbo].[PessoaFisica] ([CodPessoa])
GO
ALTER TABLE [dbo].[PessoaJuridica]  WITH CHECK ADD FOREIGN KEY([CodPessoa])
REFERENCES [dbo].[Pessoa] ([CodPessoa])
GO
ALTER TABLE [dbo].[PessoaOcupacao]  WITH CHECK ADD FOREIGN KEY([CodOcupacao])
REFERENCES [dbo].[Ocupacao] ([CodOcupacao])
GO
ALTER TABLE [dbo].[PessoaOcupacao]  WITH CHECK ADD FOREIGN KEY([CodPessoaFisica])
REFERENCES [dbo].[PessoaFisica] ([CodPessoa])
GO
ALTER TABLE [dbo].[Professor]  WITH CHECK ADD FOREIGN KEY([MatrProfessor])
REFERENCES [dbo].[Usuario] ([Matricula])
GO
ALTER TABLE [dbo].[ProfessorDisciplina]  WITH CHECK ADD  CONSTRAINT [FK_ProfessorDisciplina_Disciplina] FOREIGN KEY([CodDisciplina])
REFERENCES [dbo].[Disciplina] ([CodDisciplina])
GO
ALTER TABLE [dbo].[ProfessorDisciplina] CHECK CONSTRAINT [FK_ProfessorDisciplina_Disciplina]
GO
ALTER TABLE [dbo].[ProfessorDisciplina]  WITH CHECK ADD  CONSTRAINT [FK_ProfessorDisciplina_Professor] FOREIGN KEY([CodProfessor])
REFERENCES [dbo].[Professor] ([CodProfessor])
GO
ALTER TABLE [dbo].[ProfessorDisciplina] CHECK CONSTRAINT [FK_ProfessorDisciplina_Professor]
GO
ALTER TABLE [dbo].[ProReitoria]  WITH CHECK ADD FOREIGN KEY([CodColaboradorProReitor])
REFERENCES [dbo].[Colaborador] ([CodColaborador])
GO
ALTER TABLE [dbo].[ProReitoria]  WITH CHECK ADD FOREIGN KEY([CodInstituicao])
REFERENCES [dbo].[Instituicao] ([CodInstituicao])
GO
ALTER TABLE [dbo].[ProReitoria]  WITH CHECK ADD FOREIGN KEY([CodPessoaJuridica])
REFERENCES [dbo].[PessoaJuridica] ([CodPessoa])
GO
ALTER TABLE [dbo].[Questao]  WITH CHECK ADD FOREIGN KEY([CodDificuldade])
REFERENCES [dbo].[Dificuldade] ([CodDificuldade])
GO
ALTER TABLE [dbo].[Questao]  WITH CHECK ADD FOREIGN KEY([CodProfessor])
REFERENCES [dbo].[Professor] ([CodProfessor])
GO
ALTER TABLE [dbo].[Questao]  WITH CHECK ADD FOREIGN KEY([CodTipoQuestao])
REFERENCES [dbo].[TipoQuestao] ([CodTipoQuestao])
GO
ALTER TABLE [dbo].[QuestaoAnexo]  WITH CHECK ADD FOREIGN KEY([CodQuestao])
REFERENCES [dbo].[Questao] ([CodQuestao])
GO
ALTER TABLE [dbo].[QuestaoAnexo]  WITH CHECK ADD FOREIGN KEY([CodTipoAnexo])
REFERENCES [dbo].[TipoAnexo] ([CodTipoAnexo])
GO
ALTER TABLE [dbo].[QuestaoTema]  WITH CHECK ADD FOREIGN KEY([CodQuestao])
REFERENCES [dbo].[Questao] ([CodQuestao])
GO
ALTER TABLE [dbo].[QuestaoTema]  WITH CHECK ADD FOREIGN KEY([CodDisciplina], [CodTema])
REFERENCES [dbo].[Tema] ([CodDisciplina], [CodTema])
GO
ALTER TABLE [dbo].[Reitoria]  WITH CHECK ADD FOREIGN KEY([CodColaboradorReitor])
REFERENCES [dbo].[Colaborador] ([CodColaborador])
GO
ALTER TABLE [dbo].[Reitoria]  WITH CHECK ADD FOREIGN KEY([CodInstituicao])
REFERENCES [dbo].[Instituicao] ([CodInstituicao])
GO
ALTER TABLE [dbo].[Reitoria]  WITH CHECK ADD FOREIGN KEY([CodPessoaJuridica])
REFERENCES [dbo].[PessoaJuridica] ([CodPessoa])
GO
ALTER TABLE [dbo].[Sala]  WITH CHECK ADD FOREIGN KEY([CodCampus], [CodInstituicao])
REFERENCES [dbo].[Campus] ([CodCampus], [CodInstituicao])
GO
ALTER TABLE [dbo].[Telefone]  WITH CHECK ADD FOREIGN KEY([CodPessoa])
REFERENCES [dbo].[Pessoa] ([CodPessoa])
GO
ALTER TABLE [dbo].[Telefone]  WITH CHECK ADD FOREIGN KEY([CodTipoContato])
REFERENCES [dbo].[TipoContato] ([CodTipoContato])
GO
ALTER TABLE [dbo].[Tema]  WITH CHECK ADD FOREIGN KEY([CodDisciplina])
REFERENCES [dbo].[Disciplina] ([CodDisciplina])
GO
ALTER TABLE [dbo].[Turma]  WITH CHECK ADD FOREIGN KEY([CodCurso])
REFERENCES [dbo].[Curso] ([CodCurso])
GO
ALTER TABLE [dbo].[Turma]  WITH CHECK ADD FOREIGN KEY([CodTurno])
REFERENCES [dbo].[Turno] ([CodTurno])
GO
ALTER TABLE [dbo].[TurmaDiscAluno]  WITH CHECK ADD FOREIGN KEY([CodAluno])
REFERENCES [dbo].[Aluno] ([CodAluno])
GO
ALTER TABLE [dbo].[TurmaDiscAluno]  WITH CHECK ADD FOREIGN KEY([CodDisciplina])
REFERENCES [dbo].[Disciplina] ([CodDisciplina])
GO
ALTER TABLE [dbo].[TurmaDiscAluno]  WITH CHECK ADD  CONSTRAINT [FK__TurmaDiscAluno__53A266AC] FOREIGN KEY([NumTurma], [Periodo], [CodCurso], [CodTurno])
REFERENCES [dbo].[Turma] ([NumTurma], [Periodo], [CodCurso], [CodTurno])
GO
ALTER TABLE [dbo].[TurmaDiscAluno] CHECK CONSTRAINT [FK__TurmaDiscAluno__53A266AC]
GO
ALTER TABLE [dbo].[TurmaDiscProfHorario]  WITH CHECK ADD FOREIGN KEY([CodDisciplina])
REFERENCES [dbo].[Disciplina] ([CodDisciplina])
GO
ALTER TABLE [dbo].[TurmaDiscProfHorario]  WITH CHECK ADD FOREIGN KEY([CodDia])
REFERENCES [dbo].[DiaSemana] ([CodDia])
GO
ALTER TABLE [dbo].[TurmaDiscProfHorario]  WITH CHECK ADD FOREIGN KEY([CodProfessor])
REFERENCES [dbo].[Professor] ([CodProfessor])
GO
ALTER TABLE [dbo].[TurmaDiscProfHorario]  WITH CHECK ADD FOREIGN KEY([CodSala])
REFERENCES [dbo].[Sala] ([CodSala])
GO
ALTER TABLE [dbo].[TurmaDiscProfHorario]  WITH CHECK ADD FOREIGN KEY([NumTurma], [Periodo], [CodCurso], [CodTurno])
REFERENCES [dbo].[Turma] ([NumTurma], [Periodo], [CodCurso], [CodTurno])
GO
ALTER TABLE [dbo].[TurmaDiscProfHorario]  WITH CHECK ADD FOREIGN KEY([CodGrupo], [CodHorario], [CodTurno])
REFERENCES [dbo].[Horario] ([CodGrupo], [CodHorario], [CodTurno])
GO
ALTER TABLE [dbo].[Usuario]  WITH CHECK ADD FOREIGN KEY([CodCategoria])
REFERENCES [dbo].[Categoria] ([CodCategoria])
GO
ALTER TABLE [dbo].[Usuario]  WITH CHECK ADD FOREIGN KEY([CodPessoaFisica])
REFERENCES [dbo].[PessoaFisica] ([CodPessoa])
GO
ALTER TABLE [dbo].[UsuarioAcesso]  WITH CHECK ADD FOREIGN KEY([Matricula])
REFERENCES [dbo].[Usuario] ([Matricula])
GO
ALTER TABLE [dbo].[UsuarioAcessoPagina]  WITH CHECK ADD FOREIGN KEY([CodOrdem], [Matricula])
REFERENCES [dbo].[UsuarioAcesso] ([CodOrdem], [Matricula])
GO
ALTER TABLE [dbo].[UsuarioOpiniao]  WITH CHECK ADD FOREIGN KEY([Matricula])
REFERENCES [dbo].[Usuario] ([Matricula])
GO
ALTER TABLE [dbo].[Visitante]  WITH CHECK ADD FOREIGN KEY([MatrVisitante])
REFERENCES [dbo].[Usuario] ([Matricula])
GO
ALTER TABLE [dbo].[Pessoa]  WITH CHECK ADD CHECK  (([TipoPessoa]='J' OR [TipoPessoa]='F'))
GO
ALTER TABLE [dbo].[PessoaFisica]  WITH CHECK ADD CHECK  (([dbo].[PessoaTipoCorreto]([CodPessoa],'F')>(0)))
GO
ALTER TABLE [dbo].[PessoaFisica]  WITH CHECK ADD CHECK  (([Sexo]='M' OR [Sexo]='F' OR [Sexo]='N'))
GO
ALTER TABLE [dbo].[PessoaJuridica]  WITH CHECK ADD CHECK  (([dbo].[PessoaTipoCorreto]([CodPessoa],'J')>(0)))
GO
ALTER TABLE [dbo].[Usuario]  WITH CHECK ADD CHECK  (([dbo].[PessoaTemCategoria]([CodPessoaFisica],[CodCategoria])>(0)))
GO
USE [master]
GO
ALTER DATABASE [DB_SIAC] SET  READ_WRITE 
GO
