USE [master]
GO
/****** Object:  Database [Projecto_Planillas]    Script Date: 11/2/2022 1:33:14 PM ******/
CREATE DATABASE [Projecto_Planillas]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Projecto_Planillas', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Projecto_Planillas.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Projecto_Planillas_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Projecto_Planillas_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Projecto_Planillas] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Projecto_Planillas].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Projecto_Planillas] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Projecto_Planillas] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Projecto_Planillas] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Projecto_Planillas] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Projecto_Planillas] SET ARITHABORT OFF 
GO
ALTER DATABASE [Projecto_Planillas] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Projecto_Planillas] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Projecto_Planillas] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Projecto_Planillas] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Projecto_Planillas] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Projecto_Planillas] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Projecto_Planillas] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Projecto_Planillas] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Projecto_Planillas] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Projecto_Planillas] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Projecto_Planillas] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Projecto_Planillas] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Projecto_Planillas] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Projecto_Planillas] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Projecto_Planillas] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Projecto_Planillas] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Projecto_Planillas] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Projecto_Planillas] SET RECOVERY FULL 
GO
ALTER DATABASE [Projecto_Planillas] SET  MULTI_USER 
GO
ALTER DATABASE [Projecto_Planillas] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Projecto_Planillas] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Projecto_Planillas] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Projecto_Planillas] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Projecto_Planillas] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Projecto_Planillas] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Projecto_Planillas', N'ON'
GO
ALTER DATABASE [Projecto_Planillas] SET QUERY_STORE = OFF
GO
USE [Projecto_Planillas]
GO
/****** Object:  UserDefinedFunction [dbo].[desencriptar_pass]    Script Date: 11/2/2022 1:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[desencriptar_pass]
  (
  @clave varbinary(500)
  )
  returns varchar(50)
  as
  begin
  declare @pass as varchar(50)
  set @pass=DECRYPTBYPASSPHRASE('MiclaveSecreta',@clave)
  return @pass
  end
GO
/****** Object:  UserDefinedFunction [dbo].[ENCRIPTA_PASS]    Script Date: 11/2/2022 1:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ENCRIPTA_PASS]
 (
 @clave varchar(50)
 )
 returns VarBinary(500)
 as
 begin
 declare @pass as VarBinary(500)
 set @pass=ENCRYPTBYPASSPHRASE('MiclaveSecreta',@clave)
 return @pass
 end
GO
/****** Object:  UserDefinedFunction [dbo].[esClaveCorrecta]    Script Date: 11/2/2022 1:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[esClaveCorrecta]
(
@idUsuario int,
@claveIngresada varchar(255)
)
returns int 
as
Begin
declare @result int
declare @claveDesen varchar(255)
declare @clave varbinary(500)
select @clave=clave from Usuario where 
Usuario.IdUsuario = @idUsuario
set @claveDesen = dbo.desencriptar_pass(@clave)
if @claveDesen = @claveIngresada
begin
set @result = 1
end
else
begin
set @result = 0 
end
return @result
end
GO
/****** Object:  UserDefinedFunction [dbo].[ExisteEmpleado]    Script Date: 11/2/2022 1:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ExisteEmpleado](
@cedulaEmpleado varchar(255)
)
returns bit
begin
declare @existe bit
if exists(select cedulaEmpleado from Empleado where CedulaEmpleado = @cedulaEmpleado)
begin
set @existe = 1
end
else
begin
set @existe = 0
end
return @existe
end
GO
/****** Object:  Table [dbo].[Beneficio]    Script Date: 11/2/2022 1:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Beneficio](
	[IdBeneficio] [int] NOT NULL,
	[NombreBeneficio] [varchar](255) NOT NULL,
	[Descripcion] [varchar](255) NOT NULL,
	[Porcentaje] [float] NOT NULL,
	[Automatico] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CategoriaPago]    Script Date: 11/2/2022 1:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CategoriaPago](
	[IdCategoriaPago] [int] NOT NULL,
	[NombreCategoria] [varchar](255) NOT NULL,
	[Porcentaje] [float] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetallePlanilla]    Script Date: 11/2/2022 1:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetallePlanilla](
	[IdDetallePlanilla] [int] IDENTITY(1,1) NOT NULL,
	[IdEncabezadoPlanilla] [int] NOT NULL,
	[CedulaEmpleado] [varchar](255) NOT NULL,
	[ImpuestoRenta] [float] NULL,
	[Beneficios] [float] NULL,
	[CategoriaPago] [float] NULL,
	[SalarioBruto] [float] NULL,
	[SalarioNeto] [float] NULL,
 CONSTRAINT [PK_DetallePlanilla] PRIMARY KEY CLUSTERED 
(
	[IdDetallePlanilla] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Empleado]    Script Date: 11/2/2022 1:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Empleado](
	[CedulaEmpleado] [varchar](255) NOT NULL,
	[Nombre] [varchar](255) NOT NULL,
	[Apellidos] [varchar](255) NOT NULL,
	[Direccion] [varchar](255) NOT NULL,
	[Telefono] [int] NOT NULL,
	[FechaIngreso] [date] NOT NULL,
	[FechaSalida] [date] NULL,
	[IdPuesto] [int] NOT NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_Empleado] PRIMARY KEY CLUSTERED 
(
	[CedulaEmpleado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EncabezadoPlanilla]    Script Date: 11/2/2022 1:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EncabezadoPlanilla](
	[IdEncabezadoPlanilla] [int] IDENTITY(1,1) NOT NULL,
	[IdTipoPlanilla] [int] NOT NULL,
	[FechaInicio] [date] NOT NULL,
	[FechaFinal] [date] NOT NULL,
	[FechaPago] [date] NOT NULL,
	[Estado] [varchar](50) NOT NULL,
 CONSTRAINT [PK_EncabezadoPlanilla] PRIMARY KEY CLUSTERED 
(
	[IdEncabezadoPlanilla] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Horario]    Script Date: 11/2/2022 1:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Horario](
	[IdHorario] [int] IDENTITY(1,1) NOT NULL,
	[IdTurno] [int] NOT NULL,
	[Lunes] [bit] NOT NULL,
	[Martes] [bit] NOT NULL,
	[Miercoles] [bit] NOT NULL,
	[Jueves] [bit] NOT NULL,
	[Viernes] [bit] NOT NULL,
	[Sabado] [bit] NOT NULL,
	[Domingo] [bit] NOT NULL,
	[HoraEntrada] [time](7) NOT NULL,
	[HoraSalida] [time](7) NOT NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_Horario] PRIMARY KEY CLUSTERED 
(
	[IdHorario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ImpuestoRenta]    Script Date: 11/2/2022 1:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ImpuestoRenta](
	[MontoInicial] [float] NOT NULL,
	[MontoFinal] [float] NOT NULL,
	[Porcentaje] [float] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Puesto]    Script Date: 11/2/2022 1:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Puesto](
	[IdPuesto] [int] IDENTITY(1,1) NOT NULL,
	[NombrePuesto] [varchar](255) NOT NULL,
	[Descripcion] [varchar](255) NOT NULL,
	[PagoHora] [float] NOT NULL,
	[IdHorario] [int] NOT NULL,
	[IdTipoPlanilla] [int] NOT NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_Puesto] PRIMARY KEY CLUSTERED 
(
	[IdPuesto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoPlanilla]    Script Date: 11/2/2022 1:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoPlanilla](
	[IdTipoPlanilla] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](255) NOT NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_TipoPlanilla] PRIMARY KEY CLUSTERED 
(
	[IdTipoPlanilla] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoRol]    Script Date: 11/2/2022 1:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoRol](
	[IdTipoRol] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](255) NOT NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_TipoRol] PRIMARY KEY CLUSTERED 
(
	[IdTipoRol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Turno]    Script Date: 11/2/2022 1:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Turno](
	[IdTurno] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](255) NOT NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_Turno] PRIMARY KEY CLUSTERED 
(
	[IdTurno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuario]    Script Date: 11/2/2022 1:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuario](
	[IdUsuario] [varchar](255) NOT NULL,
	[Clave] [varbinary](500) NOT NULL,
	[IdTipoRol] [int] NOT NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_Usuario] PRIMARY KEY CLUSTERED 
(
	[IdUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DetallePlanilla]  WITH CHECK ADD  CONSTRAINT [FK_DetallePlanilla_EncabezadoPlanilla] FOREIGN KEY([IdEncabezadoPlanilla])
REFERENCES [dbo].[EncabezadoPlanilla] ([IdEncabezadoPlanilla])
GO
ALTER TABLE [dbo].[DetallePlanilla] CHECK CONSTRAINT [FK_DetallePlanilla_EncabezadoPlanilla]
GO
ALTER TABLE [dbo].[Empleado]  WITH CHECK ADD  CONSTRAINT [FK_Empleado_Puesto] FOREIGN KEY([IdPuesto])
REFERENCES [dbo].[Puesto] ([IdPuesto])
GO
ALTER TABLE [dbo].[Empleado] CHECK CONSTRAINT [FK_Empleado_Puesto]
GO
ALTER TABLE [dbo].[EncabezadoPlanilla]  WITH CHECK ADD  CONSTRAINT [FK_EncabezadoPlanilla_TipoPlanilla] FOREIGN KEY([IdTipoPlanilla])
REFERENCES [dbo].[TipoPlanilla] ([IdTipoPlanilla])
GO
ALTER TABLE [dbo].[EncabezadoPlanilla] CHECK CONSTRAINT [FK_EncabezadoPlanilla_TipoPlanilla]
GO
ALTER TABLE [dbo].[Horario]  WITH CHECK ADD  CONSTRAINT [FK_Horario_Turno] FOREIGN KEY([IdTurno])
REFERENCES [dbo].[Turno] ([IdTurno])
GO
ALTER TABLE [dbo].[Horario] CHECK CONSTRAINT [FK_Horario_Turno]
GO
ALTER TABLE [dbo].[Puesto]  WITH CHECK ADD  CONSTRAINT [FK_Puesto_Horario] FOREIGN KEY([IdHorario])
REFERENCES [dbo].[Horario] ([IdHorario])
GO
ALTER TABLE [dbo].[Puesto] CHECK CONSTRAINT [FK_Puesto_Horario]
GO
ALTER TABLE [dbo].[Puesto]  WITH CHECK ADD  CONSTRAINT [FK_Puesto_TipoPlanilla] FOREIGN KEY([IdTipoPlanilla])
REFERENCES [dbo].[TipoPlanilla] ([IdTipoPlanilla])
GO
ALTER TABLE [dbo].[Puesto] CHECK CONSTRAINT [FK_Puesto_TipoPlanilla]
GO
ALTER TABLE [dbo].[Usuario]  WITH CHECK ADD  CONSTRAINT [FK_Usuario_TipoRol] FOREIGN KEY([IdTipoRol])
REFERENCES [dbo].[TipoRol] ([IdTipoRol])
GO
ALTER TABLE [dbo].[Usuario] CHECK CONSTRAINT [FK_Usuario_TipoRol]
GO
USE [master]
GO
ALTER DATABASE [Projecto_Planillas] SET  READ_WRITE 
GO
