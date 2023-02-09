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
    [CountryCode] nvarchar(max) NOT NULL,
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

CREATE TABLE [SalesDocuments] (
    [Id] int NOT NULL IDENTITY,
    [ClientId] int NOT NULL,
    [ClientUic] nvarchar(max) NULL,
    [ClientName] nvarchar(max) NULL,
    [ClientResponsiblePerson] nvarchar(max) NULL,
    [ClientVatNumber] nvarchar(max) NULL,
    [ClientCountryId] int NULL,
    [ClientCity] nvarchar(max) NULL,
    [ClientPostalCode] nvarchar(max) NULL,
    [ClientAddressLine1] nvarchar(max) NULL,
    [ClientAddressLine2] nvarchar(max) NULL,
    [CompanyId] int NOT NULL,
    [CompanyUic] nvarchar(max) NULL,
    [CompanyName] nvarchar(max) NULL,
    [CompanyResponsiblePerson] nvarchar(max) NULL,
    [CompanyVatNumber] nvarchar(max) NULL,
    [CompanyCountryId] int NULL,
    [CompanyCity] nvarchar(max) NULL,
    [CompanyPostalCode] nvarchar(max) NULL,
    [CompanyAddressLine1] nvarchar(max) NULL,
    [CompanyAddressLine2] nvarchar(max) NULL,
    [TypeCode] nvarchar(max) NOT NULL,
    [ParentId] int NULL,
    [Number] int NOT NULL,
    [LanguageCode] nvarchar(max) NOT NULL,
    [DateOfIssue] datetime2 NOT NULL,
    [DateOfTaxEvent] datetime2 NOT NULL,
    [DueDate] datetime2 NOT NULL,
    [PlaceOfTransaction] nvarchar(max) NOT NULL,
    [Recipient] nvarchar(max) NOT NULL,
    [Notes] nvarchar(max) NULL,
    [CurrencyCode] nvarchar(max) NOT NULL,
    [TotalVatAmount] decimal(18,4) NULL,
    [TotalAmountWithoutVat] decimal(18,4) NULL,
    [TotalAmountWithVat] decimal(18,4) NULL,
    [CreatedAt] datetime2 NOT NULL,
    [UpdatedAt] datetime2 NULL,
    CONSTRAINT [PK_SalesDocuments] PRIMARY KEY ([Id])
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
    [DefaultCurrencyCode] nvarchar(max) NULL,
    [AddressId] int NOT NULL,
    [Notes] nvarchar(max) NULL,
    [StatusId] int NOT NULL,
    [CreatedAt] datetime2 NOT NULL,
    [UpdatedAt] datetime2 NULL,
    CONSTRAINT [PK_Contrahents] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Contrahents_Address_AddressId] FOREIGN KEY ([AddressId]) REFERENCES [Address] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [SalesDocumentItem] (
    [Id] int NOT NULL IDENTITY,
    [SalesDocumentId] int NOT NULL,
    [LineNumber] int NOT NULL,
    [ItemNumber] nvarchar(max) NULL,
    [Description] nvarchar(max) NULL,
    [UnitOfMeasureCode] nvarchar(max) NULL,
    [Quantity] int NOT NULL,
    [UnitPrice] decimal(18,4) NOT NULL,
    [Discount] decimal(4,2) NULL,
    [Type] nvarchar(max) NULL,
    [TaxRate] decimal(4,2) NULL,
    [VatAmount] decimal(18,4) NULL,
    [AmountWithoutVat] decimal(18,4) NULL,
    [AmountWithVat] decimal(18,4) NULL,
    CONSTRAINT [PK_SalesDocumentItem] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_SalesDocumentItem_SalesDocuments_SalesDocumentId] FOREIGN KEY ([SalesDocumentId]) REFERENCES [SalesDocuments] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [Companies] (
    [Id] int NOT NULL IDENTITY,
    [ContrahentId] int NOT NULL,
    [StatusId] int NOT NULL,
    CONSTRAINT [PK_Companies] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Companies_Contrahents_ContrahentId] FOREIGN KEY ([ContrahentId]) REFERENCES [Contrahents] ([Id]) ON DELETE CASCADE
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
    [StatusId] int NOT NULL,
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
    [Budget] decimal(18,4) NULL,
    [TypeId] int NOT NULL,
    [StartDate] datetime2 NULL,
    [EndDate] datetime2 NULL,
    [DelayedPayment] int NOT NULL,
    [Amount] decimal(18,4) NULL,
    [StatusId] int NOT NULL,
    [CreatedAt] datetime2 NOT NULL,
    [UpdatedAt] datetime2 NULL,
    CONSTRAINT [PK_Contracts] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Contracts_Contrahents_ContrahentId] FOREIGN KEY ([ContrahentId]) REFERENCES [Contrahents] ([Id])
);
GO

CREATE TABLE [ContrahentBankAccount] (
    [Id] int NOT NULL IDENTITY,
    [ContrahentId] int NOT NULL,
    [Name] nvarchar(max) NOT NULL,
    [BankName] nvarchar(max) NOT NULL,
    [Iban] nvarchar(max) NOT NULL,
    [BicCode] nvarchar(max) NOT NULL,
    [IsDefault] bit NOT NULL,
    CONSTRAINT [PK_ContrahentBankAccount] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_ContrahentBankAccount_Contrahents_ContrahentId] FOREIGN KEY ([ContrahentId]) REFERENCES [Contrahents] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [ContrahentDiscount] (
    [Id] int NOT NULL IDENTITY,
    [ContrahentId] int NOT NULL,
    [Discount] decimal(4,2) NOT NULL,
    CONSTRAINT [PK_ContrahentDiscount] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_ContrahentDiscount_Contrahents_ContrahentId] FOREIGN KEY ([ContrahentId]) REFERENCES [Contrahents] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [ContrahentVatInvoice] (
    [Id] int NOT NULL IDENTITY,
    [ContrahentId] int NOT NULL,
    [VatInvoice] decimal(4,2) NOT NULL,
    CONSTRAINT [PK_ContrahentVatInvoice] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_ContrahentVatInvoice_Contrahents_ContrahentId] FOREIGN KEY ([ContrahentId]) REFERENCES [Contrahents] ([Id]) ON DELETE CASCADE
);
GO

CREATE INDEX [IX_Companies_ContrahentId] ON [Companies] ([ContrahentId]);
GO

CREATE INDEX [IX_Contacts_AddressId] ON [Contacts] ([AddressId]);
GO

CREATE INDEX [IX_Contacts_ContrahentId] ON [Contacts] ([ContrahentId]);
GO

CREATE INDEX [IX_Contracts_ContrahentId] ON [Contracts] ([ContrahentId]);
GO

CREATE INDEX [IX_ContrahentBankAccount_ContrahentId] ON [ContrahentBankAccount] ([ContrahentId]);
GO

CREATE INDEX [IX_ContrahentDiscount_ContrahentId] ON [ContrahentDiscount] ([ContrahentId]);
GO

CREATE INDEX [IX_Contrahents_AddressId] ON [Contrahents] ([AddressId]);
GO

CREATE INDEX [IX_ContrahentVatInvoice_ContrahentId] ON [ContrahentVatInvoice] ([ContrahentId]);
GO

CREATE INDEX [IX_SalesDocumentItem_SalesDocumentId] ON [SalesDocumentItem] ([SalesDocumentId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230209161631_InitialCreate', N'7.0.0');
GO

COMMIT;
GO

