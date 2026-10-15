namespace CavesOfKharst.Forms
{
    partial class FormCharacterCreate
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
            txtCharacterName = new TextBox();
            btnSubmit = new Button();
            btnCancel = new Button();
            SuspendLayout();
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Font = new Font("Segoe UI", 24F, FontStyle.Bold, GraphicsUnit.Point, 0);
            label1.Location = new Point(12, 9);
            label1.Name = "label1";
            label1.Size = new Size(268, 45);
            label1.TabIndex = 0;
            label1.Text = "Create Character";
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label2.Location = new Point(12, 81);
            label2.Name = "label2";
            label2.Size = new Size(223, 30);
            label2.TabIndex = 1;
            label2.Text = "Enter Character Name:";
            // 
            // txtCharacterName
            // 
            txtCharacterName.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            txtCharacterName.Location = new Point(12, 114);
            txtCharacterName.Name = "txtCharacterName";
            txtCharacterName.Size = new Size(334, 35);
            txtCharacterName.TabIndex = 2;
            // 
            // btnSubmit
            // 
            btnSubmit.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            btnSubmit.Location = new Point(352, 114);
            btnSubmit.Name = "btnSubmit";
            btnSubmit.Size = new Size(120, 35);
            btnSubmit.TabIndex = 3;
            btnSubmit.Text = "Submit";
            btnSubmit.UseVisualStyleBackColor = true;
            btnSubmit.Click += btnSubmit_Click;
            // 
            // btnCancel
            // 
            btnCancel.BackColor = Color.FromArgb(255, 192, 192);
            btnCancel.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            btnCancel.Location = new Point(352, 19);
            btnCancel.Name = "btnCancel";
            btnCancel.Size = new Size(120, 35);
            btnCancel.TabIndex = 4;
            btnCancel.Text = "Back";
            btnCancel.UseVisualStyleBackColor = false;
            btnCancel.Click += btnCancel_Click;
            // 
            // FormCharacterCreate
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(484, 161);
            Controls.Add(btnCancel);
            Controls.Add(btnSubmit);
            Controls.Add(txtCharacterName);
            Controls.Add(label2);
            Controls.Add(label1);
            MinimumSize = new Size(300, 200);
            Name = "FormCharacterCreate";
            Text = "Create a Character";
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Label label1;
        private Label label2;
        private TextBox txtCharacterName;
        private Button btnSubmit;
        private Button btnCancel;
    }
}