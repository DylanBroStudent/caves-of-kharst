namespace CavesOfKharst.Forms
{
    partial class FormCharacterSelect
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            label1 = new Label();
            label2 = new Label();
            lblUser = new Label();
            btnLogout = new Button();
            listCharacters = new FlowLayoutPanel();
            tableLayoutPanel1 = new TableLayoutPanel();
            btnSettings = new Button();
            btnNewCharacter = new Button();
            listCharacters.SuspendLayout();
            SuspendLayout();
            // 
            // label1
            // 
            label1.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            label1.AutoSize = true;
            label1.Font = new Font("Segoe UI", 27.75F, FontStyle.Bold, GraphicsUnit.Point, 0);
            label1.Location = new Point(12, 9);
            label1.Name = "label1";
            label1.Size = new Size(288, 50);
            label1.TabIndex = 0;
            label1.Text = "Caves of Kharst";
            // 
            // label2
            // 
            label2.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            label2.AutoSize = true;
            label2.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label2.Location = new Point(12, 113);
            label2.Name = "label2";
            label2.Size = new Size(111, 30);
            label2.TabIndex = 4;
            label2.Text = "Characters";
            // 
            // lblUser
            // 
            lblUser.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            lblUser.AutoSize = true;
            lblUser.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            lblUser.Location = new Point(12, 59);
            lblUser.Name = "lblUser";
            lblUser.Size = new Size(136, 30);
            lblUser.TabIndex = 3;
            lblUser.Text = "Logged in as:";
            // 
            // btnLogout
            // 
            btnLogout.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            btnLogout.BackColor = Color.FromArgb(255, 192, 192);
            btnLogout.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            btnLogout.Location = new Point(468, 12);
            btnLogout.Name = "btnLogout";
            btnLogout.Size = new Size(104, 38);
            btnLogout.TabIndex = 2;
            btnLogout.Text = "Logout";
            btnLogout.UseVisualStyleBackColor = false;
            btnLogout.Click += btnLogout_Click;
            // 
            // listCharacters
            // 
            listCharacters.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            listCharacters.AutoScroll = true;
            listCharacters.BackColor = Color.Gainsboro;
            listCharacters.Controls.Add(tableLayoutPanel1);
            listCharacters.FlowDirection = FlowDirection.TopDown;
            listCharacters.Location = new Point(12, 153);
            listCharacters.Name = "listCharacters";
            listCharacters.Size = new Size(560, 296);
            listCharacters.TabIndex = 6;
            listCharacters.WrapContents = false;
            // 
            // tableLayoutPanel1
            // 
            tableLayoutPanel1.ColumnCount = 2;
            tableLayoutPanel1.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50F));
            tableLayoutPanel1.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50F));
            tableLayoutPanel1.Location = new Point(3, 3);
            tableLayoutPanel1.Name = "tableLayoutPanel1";
            tableLayoutPanel1.RowCount = 2;
            tableLayoutPanel1.RowStyles.Add(new RowStyle(SizeType.Percent, 50F));
            tableLayoutPanel1.RowStyles.Add(new RowStyle(SizeType.Percent, 50F));
            tableLayoutPanel1.Size = new Size(8, 8);
            tableLayoutPanel1.TabIndex = 0;
            // 
            // btnSettings
            // 
            btnSettings.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            btnSettings.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            btnSettings.Location = new Point(358, 12);
            btnSettings.Name = "btnSettings";
            btnSettings.Size = new Size(104, 38);
            btnSettings.TabIndex = 1;
            btnSettings.Text = "Settings";
            btnSettings.UseVisualStyleBackColor = true;
            btnSettings.Click += btnSettings_Click;
            // 
            // btnNewCharacter
            // 
            btnNewCharacter.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            btnNewCharacter.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            btnNewCharacter.Location = new Point(358, 109);
            btnNewCharacter.Name = "btnNewCharacter";
            btnNewCharacter.Size = new Size(214, 38);
            btnNewCharacter.TabIndex = 5;
            btnNewCharacter.Text = "New Character";
            btnNewCharacter.UseVisualStyleBackColor = true;
            btnNewCharacter.Click += btnNewCharacter_Click;
            // 
            // FormCharacterSelect
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            CancelButton = btnLogout;
            ClientSize = new Size(584, 461);
            Controls.Add(btnNewCharacter);
            Controls.Add(btnSettings);
            Controls.Add(listCharacters);
            Controls.Add(btnLogout);
            Controls.Add(lblUser);
            Controls.Add(label2);
            Controls.Add(label1);
            MaximumSize = new Size(600, 1500);
            MinimumSize = new Size(600, 500);
            Name = "FormCharacterSelect";
            Text = " Caves of Kharst: Characters";
            FormClosing += FormCharacterSelect_FormClosing;
            Load += FormCharacterSelect_Load;
            listCharacters.ResumeLayout(false);
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Label label1;
        private Label label2;
        private Label lblUser;
        private Button btnLogout;
        private FlowLayoutPanel listCharacters;
        private Button btnSettings;
        private Button btnNewCharacter;
        private TableLayoutPanel tableLayoutPanel1;
    }
}