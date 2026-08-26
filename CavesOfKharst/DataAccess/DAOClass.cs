using System;
using System.Windows.Forms;
using MySql.Data.MySqlClient;

namespace CavesOfKharst.DataAccess
{
    internal class DAOClass
    {
        private readonly string _connectionString =
            "Server=127.0.0.1;Database=caves_of_kharst;Uid=root;Pwd=Admin123;";

        protected MySqlConnection _connection;

        // Constructor
        public DAOClass()
        {
            _connection = new MySqlConnection(_connectionString);
        }

        public void TestConnection()
        {
            try
            {
                _connection.Open();
                MessageBox.Show("Database connection successful!");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Database connection failed: " + ex.Message);
            }
            finally
            {
                _connection.Close();
            }
        }
    }
}