package com.example.KeeperBackend.Controller;

import com.example.KeeperBackend.Model.Note;
import com.example.KeeperBackend.Service.NoteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@CrossOrigin(origins = "https://notes-flow-frontend.vercel.app")
public class NoteController {
    @Autowired
    private NoteService service;

    @GetMapping("notes")
    public List<Note> viewAllNotes(){
        return service.getAllNotes();
    }

    @PostMapping("notes")
    public Note addNote(@RequestBody Note note){
        return service.addNote(note);
    }

    @PutMapping("notes/{id}")
    public Note updateNote(@PathVariable UUID id, @RequestBody Note updatedNote){
        return service.updateNote(id,updatedNote);
    }

    @DeleteMapping("notes/{id}")
    public void deleteNote(@PathVariable UUID id){
        service.deleteNote(id);
    }

    @PatchMapping("notes/{id}/toggle-pin")
    public Note togglePin(@PathVariable UUID id){
       return service.togglePin(id);
    }

}
