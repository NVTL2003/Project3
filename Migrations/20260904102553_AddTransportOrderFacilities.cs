using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Project3.Migrations
{
    /// <inheritdoc />
    public partial class AddTransportOrderFacilities : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<Guid>(
                name: "destination_facility_id",
                table: "transport_orders",
                type: "char(36)",
                nullable: true,
                collation: "utf8mb4_0900_ai_ci");

            migrationBuilder.AddColumn<Guid>(
                name: "origin_facility_id",
                table: "transport_orders",
                type: "char(36)",
                nullable: true,
                collation: "utf8mb4_0900_ai_ci");

            migrationBuilder.CreateIndex(
                name: "IX_transport_orders_destination_facility_id",
                table: "transport_orders",
                column: "destination_facility_id");

            migrationBuilder.CreateIndex(
                name: "IX_transport_orders_origin_facility_id",
                table: "transport_orders",
                column: "origin_facility_id");

            migrationBuilder.AddForeignKey(
                name: "fk_transport_orders_destination_facility",
                table: "transport_orders",
                column: "destination_facility_id",
                principalTable: "facilities",
                principalColumn: "id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "fk_transport_orders_origin_facility",
                table: "transport_orders",
                column: "origin_facility_id",
                principalTable: "facilities",
                principalColumn: "id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "fk_transport_orders_destination_facility",
                table: "transport_orders");

            migrationBuilder.DropForeignKey(
                name: "fk_transport_orders_origin_facility",
                table: "transport_orders");

            migrationBuilder.DropIndex(
                name: "IX_transport_orders_destination_facility_id",
                table: "transport_orders");

            migrationBuilder.DropIndex(
                name: "IX_transport_orders_origin_facility_id",
                table: "transport_orders");

            migrationBuilder.DropColumn(
                name: "destination_facility_id",
                table: "transport_orders");

            migrationBuilder.DropColumn(
                name: "origin_facility_id",
                table: "transport_orders");
        }
    }
}
