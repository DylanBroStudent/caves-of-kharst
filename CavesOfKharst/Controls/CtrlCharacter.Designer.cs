namespace CavesOfKharst.Controls
{
    partial class CtrlCharacter
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

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            lblName = new Label();
            buttonPlay = new Button();
            buttonDelete = new Button();
            SuspendLayout();
            // 
            // lblName
            // 
            lblName.AutoSize = true;
            lblName.Font = new Font("Segoe UI", 20.25F, FontStyle.Bold, GraphicsUnit.Point, 0);
            lblName.ForeColor = Color.Black;
            lblName.Location = new Point(11, 24);
            lblName.Name = "lblName";
            lblName.Size = new Size(93, 37);
            lblName.TabIndex = 0;
            lblName.Text = "Name";
            // 
            // buttonPlay
            // 
            buttonPlay.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            buttonPlay.BackColor = Color.FromArgb(192, 255, 192);
            buttonPlay.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            buttonPlay.Location = new Point(397, 89);
            buttonPlay.Name = "buttonPlay";
            buttonPlay.Size = new Size(116, 40);
            buttonPlay.TabIndex = 1;
            buttonPlay.Text = "Play";
            buttonPlay.UseVisualStyleBackColor = false;
            buttonPlay.Click += buttonPlay_Click;
            // 
            // buttonDelete
            // 
            buttonDelete.BackColor = Color.FromArgb(255, 192, 192);
            buttonDelete.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            buttonDelete.Location = new Point(11, 89);
            buttonDelete.Name = "buttonDelete";
            buttonDelete.Size = new Size(116, 40);
            buttonDelete.TabIndex = 2;
            buttonDelete.TabStop = false;
            buttonDelete.Text = "Delete";
            buttonDelete.UseVisualStyleBackColor = false;
            buttonDelete.Click += buttonDelete_Click;
            // 
            // CtrlCharacter
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = Color.White;
            Controls.Add(buttonDelete);
            Controls.Add(buttonPlay);
            Controls.Add(lblName);
            Name = "CtrlCharacter";
            Size = new Size(530, 141);
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Label lblName;
        private Button buttonPlay;
        private Button buttonDelete;
    }
}
