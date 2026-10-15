using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CavesOfKharst.DataAccess
{
    internal class CharacterDAO : DAOClass
    {
        // datatable to hold characters
        public DataTable GetCharacters(int userAccountId)
        {
            try
            {
                _connection.Open();

                MySqlCommand command =
                    new MySqlCommand("character_get", _connection);

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@user_account_id_in", userAccountId);

                DataTable characters = new DataTable();

                // Use MySqlDataAdapter to fill the DataTable with the results of the stored procedure
                using (MySqlDataAdapter adapter = new MySqlDataAdapter(command))
                {
                    adapter.Fill(characters);
                }

                return characters;
            }
            finally
            {
                _connection.Close();
            }
        }

        public bool CreateCharacter(string name, int userAccountId)
        {
            try
            {
                _connection.Open();

                MySqlCommand command =
                    new MySqlCommand("character_create", _connection);

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@name_in", name);
                command.Parameters.AddWithValue("@user_account_id_in", userAccountId);

                command.ExecuteNonQuery();
                return true;
            }

            catch (MySqlException ex)
            {  
                Console.WriteLine($"Error creating character: {ex.Message}");
                return false;
            }
            finally
            {
                _connection.Close();
            }
        }

        public bool DeleteCharacter(int characterId)
        {
            try
            {
                _connection.Open();

                MySqlCommand command = new MySqlCommand("character_delete", _connection);

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@player_character_id_in", characterId);

                command.ExecuteNonQuery();
                return true;
            }
            finally
            {
                _connection.Close();
            }
        }
    }
}
