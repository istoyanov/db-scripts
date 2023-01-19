IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [Address] (
    [Id] int NOT NULL IDENTITY,
    [CountryId] int NOT NULL,
    [City] nvarchar(max) NULL,
    [CityLatin] nvarchar(max) NULL,
    [PostalCode] nvarchar(max) NULL,
    [AddressLine1] nvarchar(max) NULL,
    [AddressLine1Latin] nvarchar(max) NULL,
    [AddressLine2] nvarchar(max) NULL,
    [AddressLine2Latin] nvarchar(max) NULL,
    CONSTRAINT [PK_Address] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [Invoices] (
    [Id] int NOT NULL IDENTITY,
    [TypeId] int NOT NULL,
    [LanguageCode] nvarchar(max) NOT NULL,
    [DateOfIssue] datetime2 NOT NULL,
    [DateOfTaxEvent] datetime2 NOT NULL,
    [PlaceOfTransaction] nvarchar(max) NOT NULL,
    [CreatedAt] datetime2 NOT NULL,
    [UpdatedAt] datetime2 NULL,
    [RecipientUic] nvarchar(max) NULL,
    [RecipientName] nvarchar(max) NULL,
    [RecipientResponsiblePerson] nvarchar(max) NULL,
    [RecipientVatNumber] nvarchar(max) NULL,
    [RecipientCountryId] int NULL,
    [RecipientCity] nvarchar(max) NULL,
    [RecipientPostalCode] nvarchar(max) NULL,
    [RecipientAddressLine1] nvarchar(max) NULL,
    [RecipientAddressLine2] nvarchar(max) NULL,
    [SupplierUic] nvarchar(max) NULL,
    [SupplierName] nvarchar(max) NULL,
    [SupplierResponsiblePerson] nvarchar(max) NULL,
    [SupplierVatNumber] nvarchar(max) NULL,
    [SupplierCountryId] int NULL,
    [SupplierCity] nvarchar(max) NULL,
    [SupplierPostalCode] nvarchar(max) NULL,
    [SupplierAddressLine1] nvarchar(max) NULL,
    [SupplierAddressLine2] nvarchar(max) NULL,
    CONSTRAINT [PK_Invoices] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [Contrahents] (
    [Id] int NOT NULL IDENTITY,
    [TypeId] int NOT NULL,
    [Uic] nvarchar(max) NULL,
    [VatNumber] nvarchar(max) NULL,
    [Name] nvarchar(max) NOT NULL,
    [NameLatin] nvarchar(max) NOT NULL,
    [ResponsiblePerson] nvarchar(max) NULL,
    [ResponsiblePersonLatin] nvarchar(max) NULL,
    [DelayedPayment] int NULL,
    [Discount] decimal(18,2) NULL,
    [VatInvoice] decimal(18,2) NULL,
    [AddressId] int NOT NULL,
    [Notes] nvarchar(max) NULL,
    [CreatedAt] datetime2 NOT NULL,
    [UpdatedAt] datetime2 NULL,
    CONSTRAINT [PK_Contrahents] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Contrahents_Address_AddressId] FOREIGN KEY ([AddressId]) REFERENCES [Address] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [BankAccount] (
    [Id] int NOT NULL IDENTITY,
    [Iban] nvarchar(max) NOT NULL,
    [BicCode] nvarchar(max) NOT NULL,
    [ContrahentId] int NULL,
    CONSTRAINT [PK_BankAccount] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_BankAccount_Contrahents_ContrahentId] FOREIGN KEY ([ContrahentId]) REFERENCES [Contrahents] ([Id])
);
GO

CREATE TABLE [Clients] (
    [Id] int NOT NULL IDENTITY,
    [ContrahentId] int NOT NULL,
    [StatusId] int NOT NULL,
    CONSTRAINT [PK_Clients] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Clients_Contrahents_ContrahentId] FOREIGN KEY ([ContrahentId]) REFERENCES [Contrahents] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [Contacts] (
    [Id] int NOT NULL IDENTITY,
    [ContrahentId] int NOT NULL,
    [FirstName] nvarchar(max) NOT NULL,
    [FirstNameLatin] nvarchar(max) NOT NULL,
    [LastName] nvarchar(max) NOT NULL,
    [LastNameLatin] nvarchar(max) NOT NULL,
    [Position] nvarchar(max) NULL,
    [PositionLatin] nvarchar(max) NULL,
    [Phone] nvarchar(max) NOT NULL,
    [Email] nvarchar(max) NOT NULL,
    [AddressId] int NOT NULL,
    [CreatedAt] datetime2 NOT NULL,
    [UpdatedAt] datetime2 NULL,
    CONSTRAINT [PK_Contacts] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Contacts_Address_AddressId] FOREIGN KEY ([AddressId]) REFERENCES [Address] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Contacts_Contrahents_ContrahentId] FOREIGN KEY ([ContrahentId]) REFERENCES [Contrahents] ([Id])
);
GO

CREATE TABLE [Contracts] (
    [Id] int NOT NULL IDENTITY,
    [ContrahentId] int NOT NULL,
    [Number] nvarchar(max) NOT NULL,
    [CategoryId] int NOT NULL,
    [Subject] nvarchar(max) NOT NULL,
    [SubjectLatin] nvarchar(max) NOT NULL,
    [Budget] decimal(18,2) NULL,
    [TypeId] int NOT NULL,
    [StartDate] datetime2 NULL,
    [EndDate] datetime2 NULL,
    [DelayedPayment] int NOT NULL,
    [Amount] decimal(18,2) NULL,
    [CreatedAt] datetime2 NOT NULL,
    [UpdatedAt] datetime2 NULL,
    CONSTRAINT [PK_Contracts] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Contracts_Contrahents_ContrahentId] FOREIGN KEY ([ContrahentId]) REFERENCES [Contrahents] ([Id])
);
GO

CREATE TABLE [Suppliers] (
    [Id] int NOT NULL IDENTITY,
    [ContrahentId] int NOT NULL,
    [StatusId] int NOT NULL,
    CONSTRAINT [PK_Suppliers] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Suppliers_Contrahents_ContrahentId] FOREIGN KEY ([ContrahentId]) REFERENCES [Contrahents] ([Id]) ON DELETE CASCADE
);
GO

CREATE INDEX [IX_BankAccount_ContrahentId] ON [BankAccount] ([ContrahentId]);
GO

CREATE INDEX [IX_Clients_ContrahentId] ON [Clients] ([ContrahentId]);
GO

CREATE INDEX [IX_Contacts_AddressId] ON [Contacts] ([AddressId]);
GO

CREATE INDEX [IX_Contacts_ContrahentId] ON [Contacts] ([ContrahentId]);
GO

CREATE INDEX [IX_Contracts_ContrahentId] ON [Contracts] ([ContrahentId]);
GO

CREATE INDEX [IX_Contrahents_AddressId] ON [Contrahents] ([AddressId]);
GO

CREATE INDEX [IX_Suppliers_ContrahentId] ON [Suppliers] ([ContrahentId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20221213141352_InitialCreate', N'7.0.0');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [Contracts] ADD [StatusId] int NOT NULL DEFAULT 0;
GO

ALTER TABLE [Contacts] ADD [StatusId] int NOT NULL DEFAULT 0;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20221216075352_AddStatusColumnToCantactAndContractsTables', N'7.0.0');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [InvoiceItem] (
    [Id] int NOT NULL IDENTITY,
    [InvoiceId] int NOT NULL,
    [LineNumber] int NOT NULL,
    [ItemNumber] nvarchar(max) NULL,
    [Description] nvarchar(max) NULL,
    [UnitOfMeasure] nvarchar(max) NULL,
    [Quantity] int NOT NULL,
    [UnitPrice] decimal(18,2) NOT NULL,
    [Discount] decimal(18,2) NULL,
    [Account] nvarchar(max) NULL,
    [TaxRate] decimal(18,2) NULL,
    [VatAmount] decimal(18,2) NULL,
    [AmountWithoutVat] decimal(18,2) NULL,
    CONSTRAINT [PK_InvoiceItem] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_InvoiceItem_Invoices_InvoiceId] FOREIGN KEY ([InvoiceId]) REFERENCES [Invoices] ([Id]) ON DELETE CASCADE
);
GO

CREATE INDEX [IX_InvoiceItem_InvoiceId] ON [InvoiceItem] ([InvoiceId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20221218232433_AddInvoiceItemTable', N'7.0.0');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

EXEC sp_rename N'[Invoices].[SupplierVatNumber]', N'CompanyVatNumber', N'COLUMN';
GO

EXEC sp_rename N'[Invoices].[SupplierUic]', N'CompanyUic', N'COLUMN';
GO

EXEC sp_rename N'[Invoices].[SupplierResponsiblePerson]', N'CompanyResponsiblePerson', N'COLUMN';
GO

EXEC sp_rename N'[Invoices].[SupplierPostalCode]', N'CompanyPostalCode', N'COLUMN';
GO

EXEC sp_rename N'[Invoices].[SupplierName]', N'CompanyName', N'COLUMN';
GO

EXEC sp_rename N'[Invoices].[SupplierCountryId]', N'CompanyCountryId', N'COLUMN';
GO

EXEC sp_rename N'[Invoices].[SupplierCity]', N'CompanyCity', N'COLUMN';
GO

EXEC sp_rename N'[Invoices].[SupplierAddressLine2]', N'CompanyAddressLine2', N'COLUMN';
GO

EXEC sp_rename N'[Invoices].[SupplierAddressLine1]', N'CompanyAddressLine1', N'COLUMN';
GO

CREATE TABLE [Companies] (
    [Id] int NOT NULL IDENTITY,
    [ContrahentId] int NOT NULL,
    [StatusId] int NOT NULL,
    CONSTRAINT [PK_Companies] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Companies_Contrahents_ContrahentId] FOREIGN KEY ([ContrahentId]) REFERENCES [Contrahents] ([Id]) ON DELETE CASCADE
);
GO

CREATE INDEX [IX_Companies_ContrahentId] ON [Companies] ([ContrahentId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230102141851_AddCompanyTable', N'7.0.0');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

EXEC sp_rename N'[Invoices].[RecipientVatNumber]', N'ClientVatNumber', N'COLUMN';
GO

EXEC sp_rename N'[Invoices].[RecipientUic]', N'ClientUic', N'COLUMN';
GO

EXEC sp_rename N'[Invoices].[RecipientResponsiblePerson]', N'ClientResponsiblePerson', N'COLUMN';
GO

EXEC sp_rename N'[Invoices].[RecipientPostalCode]', N'ClientPostalCode', N'COLUMN';
GO

EXEC sp_rename N'[Invoices].[RecipientName]', N'ClientName', N'COLUMN';
GO

EXEC sp_rename N'[Invoices].[RecipientCountryId]', N'ClientCountryId', N'COLUMN';
GO

EXEC sp_rename N'[Invoices].[RecipientCity]', N'ClientCity', N'COLUMN';
GO

EXEC sp_rename N'[Invoices].[RecipientAddressLine2]', N'ClientAddressLine2', N'COLUMN';
GO

EXEC sp_rename N'[Invoices].[RecipientAddressLine1]', N'ClientAddressLine1', N'COLUMN';
GO

ALTER TABLE [Invoices] ADD [ClientId] int NOT NULL DEFAULT 0;
GO

ALTER TABLE [Invoices] ADD [CompanyId] int NOT NULL DEFAULT 0;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230102143252_RanameInvoiceClientColumns', N'7.0.0');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [Invoices] ADD [Number] int NOT NULL DEFAULT 0;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230102202231_AddInvoiceNumberColumng', N'7.0.0');
GO

COMMIT;
GO
