using CavesOfKharst.Classes;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
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

        public User Login(string email, string password, out string loginResult)
        {

            loginResult = "invalid";

            try
            {
                _connection.Open();

                MySqlCommand command = new MySqlCommand(
                    "account_login", 
                    _connection
                );

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@email_in", email);
                command.Parameters.AddWithValue("@password_in", password);

                using (MySqlDataReader reader = command.ExecuteReader())
                {
                    if (!reader.Read())
                        return null;

                    // only returns login result: failed login
                    if(reader.GetName(0) == "login_result")
                    {
                        loginResult = reader.GetString("login_result");
                        return null;
                    }

                    // returns user data: successful login
                    int id = reader.GetInt32("user_account_id");
                    string userEmail = reader.GetString("email");
                    string userPassword = reader.GetString("password");

                    loginResult = "success";
                    return new User(id, userEmail, userPassword);
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

                MySqlCommand command = new MySqlCommand(
                    "account_register", 
                    _connection
                );

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@email_in", email);
                command.Parameters.AddWithValue("@password_in", password);
                command.Parameters.AddWithValue("@administrator_flag", false);

                command.ExecuteNonQuery();
                return true;
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

        public void UpdateEmail(string oldEmail, string newEmail)
        {
            try
            {
                _connection.Open();

                MySqlCommand command = new MySqlCommand("account_update_email", _connection);

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@email_old", oldEmail);
                command.Parameters.AddWithValue("@email_new", newEmail);

                command.ExecuteNonQuery();
            }
            finally
            {
                _connection.Close();
            }
        }

        public void UpdatePassword(string email, string newPassword)
        {
            try
            {
                _connection.Open();

                MySqlCommand command = new MySqlCommand("account_update_password", _connection);

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@email_in", email);
                command.Parameters.AddWithValue("@password_new", newPassword);

                command.ExecuteNonQuery();
            }
            finally
            {
                _connection.Close();
            }
        }
        public void DeleteAccount(string email)
        {
            try
            {
                _connection.Open();

                MySqlCommand command = new MySqlCommand("account_delete", _connection);

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@email_in", email);

                command.ExecuteNonQuery();
            }
            finally
            {
                _connection.Close();
            }
        }
    }
}
