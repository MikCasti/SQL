USE [Chinook]
GO

/****** Object:  Table [dbo].[Invoice]    Script Date: 05/02/2025 11:53:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Invoice](
	[InvoiceId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[InvoiceDate] [datetime] NOT NULL,
	[BillingAddress] [nvarchar](70) NULL,
	[BillingCity] [nvarchar](40) NULL,
	[BillingState] [nvarchar](40) NULL,
	[BillingCountry] [nvarchar](40) NULL,
	[BillingPostalCode] [nvarchar](10) NULL,
	[Total] [numeric](10, 2) NOT NULL,
 CONSTRAINT [PK_Invoice] PRIMARY KEY CLUSTERED 
(
	[InvoiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Invoice]  WITH CHECK ADD  CONSTRAINT [FK_InvoiceCustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([CustomerId])
GO

ALTER TABLE [dbo].[Invoice] CHECK CONSTRAINT [FK_InvoiceCustomerId]
GO


