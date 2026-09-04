using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Project3.Migrations
{
    /// <inheritdoc />
    public partial class AddManifestItemToPackageScan : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<Guid>(
                name: "manifest_item_id",
                table: "package_scans",
                type: "char(36)",
                nullable: true,
                collation: "utf8mb4_0900_ai_ci")
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.CreateIndex(
                name: "IX_package_scans_manifest_item_id",
                table: "package_scans",
                column: "manifest_item_id");

            migrationBuilder.AddForeignKey(
                name: "fk_package_scans_manifest_item",
                table: "package_scans",
                column: "manifest_item_id",
                principalTable: "manifest_items",
                principalColumn: "id",
                onDelete: ReferentialAction.SetNull);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "fk_package_scans_manifest_item",
                table: "package_scans");

            migrationBuilder.DropIndex(
                name: "IX_package_scans_manifest_item_id",
                table: "package_scans");

            migrationBuilder.DropColumn(
                name: "manifest_item_id",
                table: "package_scans");
        }
    }
}
