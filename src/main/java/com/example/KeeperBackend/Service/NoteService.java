package com.example.KeeperBackend.Service;

import com.example.KeeperBackend.Model.Note;
import com.example.KeeperBackend.Repository.NoteRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Service
public class NoteService {
    @Autowired
    private NoteRepo repo;

    public Note addNote(Note note){
        //note.setCreatedAt(Instant.now());
        //note.setUpdatedAt(Instant.now());
        return repo.save(note);
    }

    public List<Note> getAllNotes(){
        return repo.findAll();
    }

    public void deleteNote(UUID id) {
        repo.deleteById(id);
    }

    public Note updateNote(UUID id, Note updatedNote) {
        Note existingNote = repo.findById(id).orElseThrow(() -> new RuntimeException("Note not found"));
        if(existingNote.getTitle()!=null) existingNote.setTitle(updatedNote.getTitle());
        if (updatedNote.getContent() != null) existingNote.setContent(updatedNote.getContent());
        if (updatedNote.getColor() != null) existingNote.setColor(updatedNote.getColor());
        existingNote.setPinned(updatedNote.isPinned());
        //existingNote.setUpdatedAt(Instant.now());
        return repo.save(existingNote);
    }

    public  Note togglePin(UUID id) {
        Note existingNote = repo.findById(id).orElseThrow(() -> new RuntimeException("Note not found"));
        existingNote.setPinned(!existingNote.isPinned());
        //existingNote.setUpdatedAt(Instant.now());
        return repo.save(existingNote);
    }
}
