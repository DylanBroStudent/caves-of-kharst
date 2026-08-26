using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CavesOfKharst.DataAccess
{
    internal class UserDAO : DAOClass
    {
        public UserDAO() : base()
        {

        }

        public bool Login(string email, string password)
        {
            try
            {
                _connection.Open();

                string query =
                    "SELECT * FROM user_account " +
                    "WHERE email = @email AND password = @password;";

                MySqlCommand command = new MySqlCommand(query, _connection);

                command.Parameters.AddWithValue("@email", email);
                command.Parameters.AddWithValue("@password", password);

                using (MySqlDataReader reader = command.ExecuteReader())
                {
                    return reader.Read();
                }
            }
            finally
            {
                _connection.Close();
            }
        }

        public bool Register(string email, string password)
        {
            try
            {
                _connection.Open();

                string query =
                    "INSERT INTO user_account (email, password) " +
                    "VALUES (@email, @password);";

                MySqlCommand command = new MySqlCommand(query, _connection);

                command.Parameters.AddWithValue("@email", email);
                command.Parameters.AddWithValue("@password", password);

                return command.ExecuteNonQuery() == 1;
            }
            // catch duplicates
            catch(MySqlException ex) when (ex.Number == 1062)
            {
                return false;
            }
            finally
            {
                _connection.Close();
            }
        }
    }
}
