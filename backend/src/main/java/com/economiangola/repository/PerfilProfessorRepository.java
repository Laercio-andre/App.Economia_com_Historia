// src/main/java/com/economiangola/repository/PerfilProfessorRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.PerfilProfessor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PerfilProfessorRepository extends JpaRepository<PerfilProfessor, Long> {

    Optional<PerfilProfessor> findByUsuarioId(Long usuarioId);
}
