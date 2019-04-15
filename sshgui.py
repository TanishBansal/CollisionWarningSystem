import tkinter as tk
from PIL import Image, ImageTk
from tkinter import filedialog
from itertools import count

class ImageLabel(tk.Label):
    def load(self, im):
        if isinstance(im, str):
            im = Image.open(im)
        self.loc = 0
        self.frames = []

        try:
            for i in count(1):
                self.frames.append(ImageTk.PhotoImage(im.copy()))
                im.seek(i)
        except EOFError:
            pass

        try:
            self.delay = im.info['duration']
        except:
            self.delay = 100

        if len(self.frames) == 1:
            self.config(image=self.frames[0])
        else:
            self.next_frame()

    def unload(self):
        self.config(image=None)
        self.frames = None

    def next_frame(self):
        if self.frames:
            self.loc += 1
            self.loc %= len(self.frames)
            self.config(image=self.frames[self.loc])
            self.after(self.delay, self.next_frame)

class Application(tk.Frame):
    def __init__(self, master=None):
        super().__init__(master)
        self.master = master
        self.pack()
        self.create_widgets()
        self.make_widgets()

    def make_widgets(self):
        self.winfo_toplevel().title("Collison Warning System")

    def create_widgets(self):

        self.select = tk.Button(self, text="Select Image", fg="black", command = self.SelectImage)
        # self.select.config(height = 3 , width = 5)
        self.select.pack(side="top")
        
        self.infer = tk.Button(self, text = "Infer" , fg = "green",command = self.Infer)
        # self.infer.config(height = 5 , width = 5)
        self.infer.pack(side="top")

        self.quit = tk.Button(self, text="QUIT", fg="red",command=self.master.destroy)
        self.quit.pack(side="bottom")
    
    def Infer(self):
        print("Infering {}.".format(root.filename))         
    
    def SelectImage(self):
        root.filename = filedialog.askopenfilename(filetypes=[("Image File", '.jpeg')])

root = tk.Tk()
lbl = ImageLabel(root)
lbl.pack()
lbl.load('giphy.gif')
app = Application(master=root)
app.mainloop()
