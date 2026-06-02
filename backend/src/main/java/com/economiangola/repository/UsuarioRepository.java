// src/main/java/com/economiangola/repository/UsuarioRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

    Optional<Usuario> findByEmail(String email);

    boolean existsByEmail(String email);

    Optional<Usuario> findByIdAndDeletedAtIsNull(Long id);
}
